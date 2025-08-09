class SaleItem {
  final int? id;
  final int saleId;
  final int productId;
  final String productName;
  final int quantity;
  final double price;

  SaleItem({
    this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory SaleItem.fromMap(Map<String, dynamic> map) {
    return SaleItem(
      id: map['id'] as int,
      saleId: map['saleId'] as int,
      productId: map['productId'] as int,
      productName: map['productName'] as String,
      quantity: map['quantity'] as int,
      price: map['price'] as double,
    );
  }
}
