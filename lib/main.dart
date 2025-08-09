import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:crm/screens/login_screen.dart'; // Importa la nueva pantalla de login
import 'package:crm/screens/dashboard_screen.dart';
import 'package:crm/screens/inventory_screen.dart';
import 'package:crm/screens/pos_screen.dart';
import 'package:crm/screens/add_product_screen.dart';
import 'package:crm/screens/sales_history_screen.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CRM para Restaurantes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/login', // La pantalla de login será la primera
      routes: {
        '/login': (context) => const LoginScreen(),
        '/': (context) => const DashboardScreen(),
        '/inventory': (context) => const InventoryScreen(),
        '/pos': (context) => const PosScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/sales_history': (context) => const SalesHistoryScreen(),
      },
    );
  }
}
