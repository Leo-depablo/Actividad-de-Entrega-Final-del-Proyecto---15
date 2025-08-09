class Product {
  final int? id;
  final String name;
  final double price;
  final int stock;
  final String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.imageUrl,
  });

  // Convierte un objeto Product en un Map para la base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'stock': stock,
      'imageUrl': imageUrl,
    };
  }

  // Crea un objeto Product a partir de un Map de la base de datos
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      name: map['name'] as String,
      price: map['price'] as double,
      stock: map['stock'] as int,
      imageUrl: map['imageUrl'] as String,
    );
  }
}
