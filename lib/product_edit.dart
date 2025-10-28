import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({super.key});

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController(text: "Product Name");
  final TextEditingController _stockController = TextEditingController(text: "10");
  final TextEditingController _supplierController = TextEditingController(text: "ABC Supplies");

  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Here you’d normally update the database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product details updated successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Product"),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // --- Image Preview + Button ---
              GestureDetector(
                onTap: _pickImage,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: _imageFile != null
                      ? Image.file(
                          _imageFile!,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 180,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: const Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Product Name ---
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 20),

              // --- Stock ---
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock Quantity',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter stock quantity' : null,
              ),
              const SizedBox(height: 20),

              // --- Supplier ---
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: 'Supplier Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter supplier name' : null,
              ),
              const SizedBox(height: 40),

              // --- Save Button ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _saveChanges,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

