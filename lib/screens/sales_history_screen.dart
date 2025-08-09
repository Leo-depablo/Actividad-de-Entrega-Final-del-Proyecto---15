import 'package:flutter/material.dart';
import 'package:crm/models/sale.dart';
import 'package:crm/models/sale_item.dart';
import 'package:crm/services/sale_service.dart';

class SalesHistoryScreen extends StatefulWidget {
  const SalesHistoryScreen({super.key});

  @override
  State<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends State<SalesHistoryScreen> {
  final SaleService _saleService = SaleService();
  late Future<List<Sale>> _salesFuture;

  @override
  void initState() {
    super.initState();
    _salesFuture = _saleService.getAllSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Ventas'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Sale>>(
        future: _salesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay ventas registradas.'));
          } else {
            final sales = snapshot.data!;
            return ListView.builder(
              itemCount: sales.length,
              itemBuilder: (context, index) {
                final sale = sales[index];
                return _buildSaleExpansionTile(sale);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildSaleExpansionTile(Sale sale) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        leading: const Icon(Icons.receipt, color: Colors.blueAccent),
        title: Text('Venta #${sale.id}'),
        subtitle: Text(
          'Total: \$${sale.totalAmount.toStringAsFixed(2)}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        children: <Widget>[
          FutureBuilder<List<SaleItem>>(
            future: _saleService.getSaleItems(sale.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error al cargar ítems: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const ListTile(
                  title: Text('No hay ítems para esta venta.'),
                );
              } else {
                final items = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, itemIndex) {
                    final item = items[itemIndex];
                    return ListTile(
                      title: Text(item.productName),
                      subtitle: Text('Cantidad: ${item.quantity}'),
                      trailing: Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                      ),
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
