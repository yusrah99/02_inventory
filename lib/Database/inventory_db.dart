
class Product {
  final int? id;
  final String name;
  final String code;
  final int stock;
  final String supplier;
  final double pricePerKg;
  final String? imagePath; // optional image path or base64 string

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.stock,
    required this.supplier,
    required this.pricePerKg,
    this.imagePath,
  });

  // Convert Product object to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'stock': stock,
      'supplier': supplier,
      'price': pricePerKg,
      'imagePath': imagePath,
    };
  }

  // Convert database Map back to Product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      stock: map['stock'],
      supplier: map['supplier'],
      pricePerKg: map['price'],
      imagePath: map['imagePath'],
    );
  }
}
