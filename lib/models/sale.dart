import 'package:crm/models/sale_item.dart';

class Sale {
  final int? id;
  final String date;
  final double totalAmount;
  final List<SaleItem> items;

  Sale({
    this.id,
    required this.date,
    required this.totalAmount,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'date': date, 'totalAmount': totalAmount};
  }

  factory Sale.fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'] as int,
      date: map['date'] as String,
      totalAmount: map['totalAmount'] as double,
    );
  }
}
