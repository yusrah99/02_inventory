import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/Database/db_helper.dart';
import 'package:hng2_inventory_app/Database/inventory_db.dart';
import 'package:hng2_inventory_app/product_edit.dart';

class ProductPage extends StatefulWidget {
  final Product product;

  const ProductPage({super.key, required this.product});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late Product product;
  final dbHelper = DbHelper();

  @override
  void initState() {
    super.initState();
    product = widget.product;
  }

  // refresh product details from database
  Future<void> _refreshProduct() async {
    if (product.id .isNotEmpty) {
      final updatedProduct = await dbHelper.getProductById(product.id!);
      if (updatedProduct != null) {
        setState(() {
          product = updatedProduct;
        
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(product.name),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProduct,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Product Image
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.blue[200],
                    child: product.imagePath != null && File(product.imagePath!).existsSync()
                        ? Image.file(File(product.imagePath!), fit: BoxFit.cover)
                        : const Icon(Icons.image_not_supported, size: 100),
                  ),
                ),
              ),

              // Product details
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Name
                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Product Code
                        Row(
                          children: [
                            const Icon(Icons.qr_code, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Code: ${product.code}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Product Stock
                        Row(
                          children: [
                            const Icon(Icons.inventory_2, color: Colors.grey),
                            const SizedBox(width: 8),
                            Text(
                              'Stock: ${product.stock} units',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Product Supplier
                        Row(
                          children: [
                            const Icon(Icons.local_shipping, color: Colors.grey),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Supplier: ${product.supplier}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        //  Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                final updatedProduct = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditProduct(
                                      product: product.toMap(),
                                    ),
                                  ),
                                );

                                if (updatedProduct != null) {
                                  //  Refresh from database and update UI
                                  await _refreshProduct();
                                }
                              },
                              icon: const Icon(Icons.edit, color: Colors.white),
                              label: const Text("Edit", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () async {
                                if (product.id != null) {
                                  await dbHelper.deleteProduct(product.id!);
                                  if (mounted) {
                                    Navigator.pop(context);
                                  }
                                }
                              },
                              icon: const Icon(Icons.delete, color: Colors.white),
                              label: const Text("Delete", style: TextStyle(color: Colors.white)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
