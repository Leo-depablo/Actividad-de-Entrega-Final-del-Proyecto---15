import 'package:flutter/material.dart';
import 'package:crm/services/sale_service.dart';
import 'package:crm/screens/inventory_screen.dart';
import 'package:crm/screens/pos_screen.dart';
import 'package:crm/screens/sales_history_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final SaleService _saleService = SaleService();
  late Future<double> _totalSalesFuture;

  @override
  void initState() {
    super.initState();
    _loadTotalSales();
  }

  void _loadTotalSales() {
    _totalSalesFuture = _saleService.getTotalSalesAmount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menú Principal',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text('Dashboard'),
              onTap: () {
                _loadTotalSales();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory),
              title: const Text('Inventario'),
              onTap: () {
                Navigator.pushNamed(context, '/inventory');
              },
            ),
            ListTile(
              leading: const Icon(Icons.point_of_sale),
              title: const Text('Ventas POS'),
              onTap: () async {
                await Navigator.pushNamed(context, '/pos');
                setState(() {
                  _loadTotalSales();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Historial de Ventas'),
              onTap: () {
                Navigator.pushNamed(context, '/sales_history');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumen del Día',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildTotalSalesCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSalesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text(
              'Ventas Totales',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            FutureBuilder<double>(
              future: _totalSalesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text(
                    'Error al cargar las ventas',
                    style: TextStyle(fontSize: 24),
                  );
                } else {
                  final totalSales = snapshot.data ?? 0.0;
                  return Text(
                    '\$${totalSales.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
