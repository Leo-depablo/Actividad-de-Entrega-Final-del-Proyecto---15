import 'package:sqflite/sqflite.dart';
import 'package:crm/models/sale.dart';
import 'package:crm/models/sale_item.dart';
import 'package:crm/services/database_service.dart';

class SaleService {
  final _databaseService = DatabaseService();

  Future<void> addSale(Sale sale, List<SaleItem> items) async {
    final db = await _databaseService.database;

    await db.transaction((txn) async {
      final saleId = await txn.insert(
        'sales',
        sale.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var item in items) {
        final saleItemMap = item.toMap();
        saleItemMap['saleId'] = saleId;
        await txn.insert(
          'sale_items',
          saleItemMap,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );

        await txn.rawUpdate(
          'UPDATE products SET stock = stock - ? WHERE id = ?',
          [item.quantity, item.productId],
        );
      }
    });
  }

  Future<double> getTotalSalesAmount() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT SUM(totalAmount) as total FROM sales',
    );

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    }
    return 0.0;
  }

  Future<List<Sale>> getAllSales() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('sales');
    return List.generate(maps.length, (i) {
      return Sale.fromMap(maps[i]);
    });
  }

  Future<List<SaleItem>> getSaleItems(int saleId) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sale_items',
      where: 'saleId = ?',
      whereArgs: [saleId],
    );
    return List.generate(maps.length, (i) {
      return SaleItem.fromMap(maps[i]);
    });
  }
}
