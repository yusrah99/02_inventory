
import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/Database/inventory_db.dart';
import 'package:hng2_inventory_app/product.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hng2_inventory_app/Database/db_helper.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  final dbHelper = DbHelper();
  File? _image;

  // Pick image
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Save product to database
  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      // Create product WITHOUT id
      final product = Product(
        id: null,
        name: _nameController.text.trim(),
        stock: int.tryParse(_stockController.text.trim()) ?? 0,
        pricePerKg: double.tryParse(_priceController.text.trim()) ?? 0.0,
        code: _codeController.text.trim(),
        supplier: _supplierController.text.trim(),
        imagePath: _image?.path ?? '',
      );

      // Insert into DB and get the new ID
      final id = await dbHelper.insertProduct(product);

      // Create product with ID to return
      final newProduct = Product(
        id: id,
        name: product.name,
        stock: product.stock,
        pricePerKg: product.pricePerKg,
        code: product.code,
        supplier: product.supplier,
        imagePath: product.imagePath,
      );

      // Return to HomePage
      Navigator.pop(context, newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully!')),
      );

      // Clear form
      _nameController.clear();
      _stockController.clear();
      _priceController.clear();
      _codeController.clear();
      _supplierController.clear();
      setState(() {
        _image = null;
      });
    }
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.teal, width: 2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Add New Product', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Image Picker
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => Container(
                        padding: const EdgeInsets.all(10),
                        height: 150,
                        child: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.photo_camera),
                              title: const Text('Take a Photo'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.camera);
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Choose from Gallery'),
                              onTap: () {
                                Navigator.pop(context);
                                _pickImage(ImageSource.gallery);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: _image == null
                          ? const Center(
                              child: Icon(Icons.camera_alt, size: 60, color: Colors.teal),
                            )
                          : Image.file(_image!, fit: BoxFit.cover),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Name
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration('Product Name'),
                  validator: (value) => value!.isEmpty ? 'Enter a product name' : null,
                ),
                const SizedBox(height: 15),

                // Stock Quantity
                TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Stock Quantity'),
                  validator: (value) => value!.isEmpty ? 'Enter stock quantity' : null,
                ),
                const SizedBox(height: 15),

                // Price
                TextFormField(
                  controller: _priceController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: _inputDecoration('Product Price (₦)'),
                  validator: (value) => value!.isEmpty ? 'Enter product price' : null,
                ),
                const SizedBox(height: 15),

                // Product Code
                TextFormField(
                  controller: _codeController,
                  decoration: _inputDecoration('Product Code'),
                  validator: (value) => value!.isEmpty ? 'Enter product code' : null,
                ),
                const SizedBox(height: 15),

                // Supplier
                TextFormField(
                  controller: _supplierController,
                  decoration: _inputDecoration('Supplier Name'),
                  validator: (value) => value!.isEmpty ? 'Enter supplier name' : null,
                ),
                const SizedBox(height: 25),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Save Product',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
