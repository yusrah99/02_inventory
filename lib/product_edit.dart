import 'package:flutter/material.dart';
import 'dart:io';
import 'package:hng2_inventory_app/Database/db_helper.dart';

class EditProduct extends StatefulWidget {
  final Map<String, dynamic> product; 

  const EditProduct({super.key, required this.product});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _stockController;
  late TextEditingController _supplierController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _stockController =
        TextEditingController(text: widget.product['stock'].toString());
    _supplierController =
        TextEditingController(text: widget.product['supplier'] ?? '');
    _priceController =
        TextEditingController(text: widget.product['price'].toString());
  }

  @override
  void dispose() {
    _stockController.dispose();
    _supplierController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _updateProduct() async {
    if (_formKey.currentState!.validate()) {
      final dbHelper = DbHelper();
      final db = await dbHelper.database;

      // Create updated map
      final updatedProduct = {
        'id': widget.product['id'],
        'name': widget.product['name'], 
        'code': widget.product['code'], 
        'stock': int.tryParse(_stockController.text) ?? 0,
        'supplier': _supplierController.text,
        'price': double.tryParse(_priceController.text) ?? 0.0,
        'imagePath': widget.product['imagePath'], 
      };

      await db.update(
        'products',
        updatedProduct,
        where: 'id = ?',
        whereArgs: [widget.product['id']],
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Product details updated successfully!'),
            backgroundColor: Colors.teal,
          ),
        );

        // 👇 Return updated product map to previous screen
        Navigator.pop(context, updatedProduct);
      }
    }
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 80, color: Colors.grey);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, height: 180, fit: BoxFit.cover);
    }
    return Image.file(File(path), height: 180, fit: BoxFit.cover);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit ${product['name']}"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _buildImage(product['imagePath']),
              ),
              const SizedBox(height: 25),

              // Stock no.
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Stock Quantity',
                  prefixIcon: const Icon(Icons.inventory_2, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter stock quantity' : null,
              ),
              const SizedBox(height: 20),

              // Supplier
              TextFormField(
                controller: _supplierController,
                decoration: InputDecoration(
                  labelText: 'Supplier Name',
                  prefixIcon: const Icon(Icons.local_shipping, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter supplier name' : null,
              ),
              const SizedBox(height: 20),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Product Price',
                  prefixIcon: const Icon(Icons.attach_money, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter product price' : null,
              ),
              const SizedBox(height: 40),

              //  Save Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    'Save Changes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _updateProduct,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
