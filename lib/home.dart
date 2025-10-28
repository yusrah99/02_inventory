




import 'package:flutter/material.dart';

/// Simple product model
class Product {
  final String id;         // unique id used by Dismissible
  final String name;       // product name
  int stock;               // product stock (mutable for demo)
  final String imageUrl;   // url to product image

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.imageUrl,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sample product list (in a real app this would come from a backend or DB)
  final List<Product> _products = List.generate(
    10,
    (i) => Product(
      id: 'p$i',
      name: 'Product #$i',
      stock: 5 + i,
      imageUrl: 'https://picsum.photos/seed/p$i/200/200', // placeholder image
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: CustomScrollView(
        slivers: [
          // ---------- Your SliverAppBar ----------
          SliverAppBar(
            leading: Icon(Icons.menu),                // left icon
            actions: [Icon(Icons.search)],            // right icon(s)
            title: Text('I N V E N T O R Y'),        // title text
            expandedHeight: 300,                      // height when expanded
            pinned: true,                             // keep app bar visible when scrolled
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.teal[300],
                alignment: Alignment.center,
                child: Text(
                  'Welcome',
                  style: TextStyle(fontSize: 28, color: Colors.white70),
                ),
              ),
            ),
          ),

          // ---------- Optional header inside scroll (non-sliver widget adapted) ----------
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Products',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // ---------- The product list implemented as a SliverList ----------
          SliverList(
            // SliverChildBuilderDelegate lazily builds list items (recommended)
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final product = _products[index];

                // Dismissible makes swipe-to-delete behaviour.// USE SLIDEABLE HERE INSTEAD 
                return Dismissible(
                  key: ValueKey(product.id), // unique key for each item
                  direction: DismissDirection.endToStart, // swipe left only
                  background: Container(
                    // background shown behind the item while swiping
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),

                  // confirmDismiss allows showing a dialog before actually deleting //FIND SOMETHING FOR THIS TOO 
                  confirmDismiss: (direction) async {
                    final result = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Delete ${product.name}?'),
                        content: Text('Are you sure you want to delete this product?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    return result == true;
                  },

                  // onDismissed is called after confirmDismiss returns true
                  onDismissed: (direction) {
                    setState(() {
                      _products.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${product.name} deleted')),
                    );
                  },

                  child: Container(
                    // Visual container for each list item
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    // The row holds the image on the left and details on the right
                    child: Row(
                      children: [
                        // Left: product image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.imageUrl,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, err, stack) => Container(
                              width: 100,
                              height: 100,
                              color: Colors.grey[200],
                              alignment: Alignment.center,
                              child: Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),

                        SizedBox(width: 12),

                        // Middle: name and stock (expands to take available space)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 6),
                              Text('Stock: ${product.stock}'),
                            ],
                          ),
                        ),

                        // Right: a small button to reduce stock (example action)// NOT ADDED
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (product.stock > 0) product.stock -= 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              childCount: _products.length, // number of items in the list
            ),
          ),

          // Optional footer or spacing
          SliverToBoxAdapter(
            child: SizedBox(height: 32),
          ),
        ],
      ),
    );
  }
}
