import 'package:flutter/material.dart';
import 'package:kio_brend/services/product_sevice.dart';
import 'package:provider/provider.dart';
import 'screens/catalog_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ProductService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Online Store',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: CatalogScreen(),
      ),
    );
  }
}
