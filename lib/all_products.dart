import 'package:flutter/material.dart';

class AllProduct extends StatefulWidget {
  const AllProduct({super.key});

  @override
  State<AllProduct> createState() => _AllProductState();
}

class _AllProductState extends State<AllProduct> {
  // A list of all products (dummy data for now)
  List<Map<String, dynamic>> products = [
    {
      'name': 'Rice Bag',
      'stock': 30,
      'supplier': 'AgroMart',
      'code': 'PRD001',
      'image': 'https://via.placeholder.com/100'
    },
    {
      'name': 'Groundnut Oil',
      'stock': 12,
      'supplier': 'SunCo Foods',
      'code': 'PRD002',
      'image': 'https://via.placeholder.com/100'
    },
    {
      'name': 'Wheat Flour',
      'stock': 8,
      'supplier': 'Golden Mills',
      'code': 'PRD003',
      'image': 'https://via.placeholder.com/100'
    },
  ];

  // A filtered list that changes as user searches
  List<Map<String, dynamic>> filteredProducts = [];

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initially show all products
    filteredProducts = products;

    // Listen to changes in the search bar
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products.where((product) {
        return product['name'].toLowerCase().contains(query) ||
            product['supplier'].toLowerCase().contains(query) ||
            product['code'].toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Products'),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Padding(
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

            // 🧾 List of Products
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
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 3,
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                product['image'],
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              product['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                                'Stock: ${product['stock']} • Supplier: ${product['supplier']}'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              // Navigate to detail page later
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
