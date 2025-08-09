import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'crm_restaurante.db');

    return await openDatabase(
      path,
      version: 1, // Se mantiene en 1 para este prototipo
      onCreate: (db, version) async {
        // Crear la tabla de productos
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            price REAL,
            stock INTEGER,
            imageUrl TEXT
          )
        ''');

        // Crear la tabla de ventas
        await db.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            totalAmount REAL
          )
        ''');

        // Crear la tabla de ítems de venta
        await db.execute('''
          CREATE TABLE sale_items(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            saleId INTEGER,
            productId INTEGER,
            productName TEXT,
            quantity INTEGER,
            price REAL,
            FOREIGN KEY(saleId) REFERENCES sales(id) ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}
