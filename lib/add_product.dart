
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to capture user input
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _supplierController = TextEditingController();

  File? _image; // To hold selected image

  // Function to pick image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Function to handle form submission
  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // You can later save this data to Firebase, SQLite, etc.
      print('Product Name: ${_nameController.text}');
      print('Stock: ${_stockController.text}');
      print('Code: ${_codeController.text}');
      print('Supplier: ${_supplierController.text}');
      print('Image: $_image');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Product Image Section
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (_) => Container(
                      padding: const EdgeInsets.all(20),
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
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter a product name' : null,
              ),
              const SizedBox(height: 15),

              // Stock Quantity
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter stock quantity' : null,
              ),
              const SizedBox(height: 15),

              // Product Code
              TextFormField(
                controller: _codeController,
                decoration: const InputDecoration(
                  labelText: 'Product Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter product code' : null,
              ),
              const SizedBox(height: 15),

              // Supplier Name
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Enter supplier name' : null,
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
                  ),
                  child: const Text(
                    'Save Product',
                    style: TextStyle(fontSize: 18),
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
