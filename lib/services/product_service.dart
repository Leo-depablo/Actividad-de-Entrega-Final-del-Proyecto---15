import 'package:sqflite/sqflite.dart';
import 'package:crm/models/product.dart';
import 'package:crm/services/database_service.dart';

class ProductService {
  final _databaseService = DatabaseService();

  // Función para crear (agregar) un nuevo producto
  Future<void> addProduct(Product product) async {
    final db = await _databaseService.database;
    await db.insert(
      'products', // Nombre de la tabla
      product.toMap(), // El mapa de datos del producto
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Función para leer (obtener) todos los productos
  Future<List<Product>> getProducts() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('products');

    // Convierte la lista de mapas a una lista de objetos Product
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Función para actualizar un producto existente
  Future<void> updateProduct(Product product) async {
    final db = await _databaseService.database;
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Función para eliminar un producto
  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }
}
