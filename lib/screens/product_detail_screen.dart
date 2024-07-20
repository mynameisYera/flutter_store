import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:kio_brend/services/product_sevice.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'package:pay/pay.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  ProductDetailScreen({required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Future<String> googlePayConfigFuture;

  @override
  void initState() {
    super.initState();
    googlePayConfigFuture = DefaultAssetBundle.of(context).loadString('assets/google_payment.json');
  }

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Детали продукта'),
        leading: BackButton(),
      ),
      body: FutureBuilder<Product>(
        future: productService.fetchProductById(widget.productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Product not found'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(),
                  itemCount: product.imageUrl.length,
                  itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.asset(product.imageUrl[itemIndex], width: MediaQuery.of(context).size.width),
                        ),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      Text(product.category, style: TextStyle(color: Colors.grey)),
                      Text('\$${product.price}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(product.description),
                      SizedBox(height: 10),
                      FutureBuilder<String>(
                        future: googlePayConfigFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error loading Google Pay configuration'));
                          }

                          var googlePayButton = GooglePayButton(
                            paymentConfiguration: PaymentConfiguration.fromJsonString(snapshot.data!),
                            paymentItems: const [
                              PaymentItem(
                                
                                label: 'Total: ',
                                amount: '0.02',
                                status: PaymentItemStatus.final_price,
                              ),
                            ],
                            width: MediaQuery.of(context).size.width,
                            type: GooglePayButtonType.pay,
                            onPaymentResult: (result) => debugPrint("Payment Result $result"),
                            loadingIndicator: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          return googlePayButton;
                        },
                      ),
                      SizedBox(height: 10),
                      Text('Общий рейтинг: ${product.rating}', style: TextStyle(fontSize: 18)),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < product.rating ? Icons.star : Icons.star_border,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
