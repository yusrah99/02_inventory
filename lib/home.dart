import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hng2_inventory_app/Database/db_helper.dart';
import 'package:hng2_inventory_app/Database/inventory_db.dart';
import 'package:hng2_inventory_app/add_product.dart';
import 'package:hng2_inventory_app/all_products.dart';
import 'package:hng2_inventory_app/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DbHelper dbHelper = DbHelper();
  List<Product> _allProducts = [];
  List<Product> _displayedProducts = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  // Reload products whenever page is shown
  Future<void> _loadProducts() async {
    final data = await dbHelper.getProducts();
    if (mounted) {
      setState(() {
        _allProducts = data;
        _displayedProducts = _allProducts.where((p) => p.stock < 30).toList();
      });
    }
  }

  // Go to product details and refresh when back
  Future<void> _openProduct(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ProductPage(product: product)),
    );
     // refresh after returning
    _loadProducts();
  }


void _openAddProductPage() async {
  final newProduct = await Navigator.push<Product>(
    context,
    MaterialPageRoute(builder: (context) => const AddProduct()),
  );

  if (newProduct != null) {
    setState(() {
      _allProducts.add(newProduct);
      _displayedProducts = _allProducts.where((p) => p.stock < 30).toList();
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      body: RefreshIndicator(
        onRefresh: _loadProducts,
        child: CustomScrollView(
          slivers: [
           SliverAppBar(
              pinned: true,
              floating: true,
              backgroundColor: Colors.teal,
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  padding: const EdgeInsets.all(16),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Stock",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      Text(
                        "${_allProducts.fold<int>(0, (sum, p) => sum + (p.stock ?? 0))} items",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12, top: 8),
                  child: GestureDetector(
                    onTap: () async {
                      // Open Add Product Page
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const AddProduct()),
                      );
                      // to refresh product list after adding new product
                      _loadProducts(); 
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Low Stock Products',
                      style: TextStyle(
                        color: Colors.teal,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // go to all products and refresh when back
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AllProduct()),
                        );
                        _loadProducts();
                      },
                      child: const Text(
                        'All Products',
                        style: TextStyle(
                          color: Colors.teal,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product List 
            _displayedProducts.isEmpty
                ? const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'No products to show',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _displayedProducts[index];
                        final bool isLowStock = product.stock < 30;

                        return GestureDetector(
                          onTap: () => _openProduct(product),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),

                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: _buildImage(product.imagePath),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.name,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Text('Stock: ${product.stock}'),
                                          if (isLowStock) ...[
                                            const SizedBox(width: 6),
                                            const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.redAccent,
                                              size: 18,
                                            ),
                                          ],
                                        ],
                                      ),
                                      Text(
                                          'Price: ₦${product.pricePerKg} per kg'),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      childCount: _displayedProducts.length,
                    ),
                  ),

            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }

  // To handle image display from assets or file system
  Widget _buildImage(String? path) {
    if (path == null || path.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 64);
    }

    if (path.startsWith('assets/')) {
      return Image.asset(
        path,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 64),
      );
    } else {
      return Image.file(
        File(path),
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.image_not_supported, size: 64),
      );
    }
  }
}










