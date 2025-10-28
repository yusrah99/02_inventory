import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/add_product.dart';
import 'package:hng2_inventory_app/all_products.dart';
import 'package:hng2_inventory_app/home.dart';
import 'package:hng2_inventory_app/product.dart';
import 'package:hng2_inventory_app/product_edit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const EditProduct()
    );
  }
}

