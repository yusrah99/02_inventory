class Product{
  final String id;
  final String name;
  final String code;
  final int image;
  final String supplier;

  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.image,
    required this.supplier,
  });


//converting product to map for db storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'stock': image,
      'supplier': supplier,
    };
  }

  //Converting the map from the db back to a product object
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      code: map['code'],
      image: map['stock'],
      supplier: map['supplier'],
    );
  }
}
