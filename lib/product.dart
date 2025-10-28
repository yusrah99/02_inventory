import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // Sample product data — in a real app, this might come from a database or API
  final String productName = "Wireless Keyboard";
  final int stock = 25;
  final String productCode = "WK-2025";
  final String supplier = "Tech World Supplies Ltd.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent AppBar to give a clean overlay feel
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Product Page'),
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 🖼 First container (Product Image)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 300,
                width: double.infinity,
                color: Colors.blue[200],
                child: Image.network(
                  'https://picsum.photos/seed/product/600/400', // Placeholder image
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 🧾 Second container (Product Details)
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
                      productName,
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
                          'Code: $productCode',
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
                          'Stock: $stock units',
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
                            'Supplier: $supplier',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Action buttons (optional)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.edit),
                          label: const Text("Edit"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete"),
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
    );
  }
}
