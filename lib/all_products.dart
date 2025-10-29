import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/Database/db_helper.dart';
import 'package:hng2_inventory_app/Database/inventory_db.dart';
import 'package:hng2_inventory_app/product.dart'; 
 

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_filterProducts);
  }

  Future<void> _loadProducts() async {
    final dbHelper = DbHelper();
    final db = await dbHelper.database;
    final data = await db.query('products');
    setState(() {
      products = data;
      filteredProducts = data;
    });
  }
// Search filter
  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        final name = product['name']?.toString().toLowerCase() ?? '';
        final supplier = product['supplier']?.toString().toLowerCase() ?? '';
        final code = product['code']?.toString().toLowerCase() ?? '';
        return name.contains(query) ||
            supplier.contains(query) ||
            code.contains(query);
      }).toList();
    });
  }

  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }
    if (path.startsWith('assets/')) {
      return Image.asset(path, width: 60, height: 60, fit: BoxFit.cover);
    }
    return Image.file(File(path), width: 60, height: 60, fit: BoxFit.cover);
  }

  void _openProductDetails(Map<String, dynamic> productMap) {
    final product = Product(
      id: productMap['id'],
      name: productMap['name'],
      code: productMap['code'],
      stock: productMap['stock'],
      supplier: productMap['supplier'],
      pricePerKg: productMap['price'],
      imagePath: productMap['imagePath'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        title: const Text('All Products', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // 🔍 Search Bar
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, supplier, or code...',
                  prefixIcon: const Icon(Icons.search, color: Colors.teal),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Product List
              Expanded(
                child: filteredProducts.isEmpty
                    ? const Center(
                        child: Text(
                          'No products found',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _buildImage(product['imagePath']),
                              ),
                              title: Text(
                                product['name'] ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                'Stock: ${product['stock']} • Supplier: ${product['supplier']}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => _openProductDetails(product),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
