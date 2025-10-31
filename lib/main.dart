import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/Database/db_helper.dart';
import 'package:hng2_inventory_app/Database/product_list.dart';
import 'package:hng2_inventory_app/home.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FFI (for desktop)
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DbHelper dbHelper = DbHelper();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
   // _initializeDatabase();
  }

  Future<void> _initializeDatabase() async {
    // Insert seafood products only once
    //await dbHelper.insertSeafoodProducts(seafoodProducts);

    // Check existing products
    final existingProducts = await dbHelper.getProducts();

    if (existingProducts.isEmpty) {
      for (var product in seafoodProducts) {
        await dbHelper.insertProduct(product);
      }
      print("Inserted sample seafood products into database");
    } else {
      print("Database already has ${existingProducts.length} products");
    }

    // Update UI after DB setup
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seafood Inventory',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: 
          const HomePage(),
    );
  }
}
