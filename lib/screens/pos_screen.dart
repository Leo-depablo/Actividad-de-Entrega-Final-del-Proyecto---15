import 'package:flutter/material.dart';
import 'package:crm/models/product.dart';
import 'package:crm/models/sale.dart';
import 'package:crm/models/sale_item.dart';
import 'package:crm/services/product_service.dart';
import 'package:crm/services/sale_service.dart';

class PosScreen extends StatefulWidget {
  const PosScreen({super.key});

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  final ProductService _productService = ProductService();
  final SaleService _saleService = SaleService();
  late Future<List<Product>> _productsFuture;
  List<SaleItem> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts();
  }

  void _addToCart(Product product) {
    setState(() {
      final existingItem = _cartItems.firstWhere(
        (item) => item.productId == product.id,
        orElse: () => SaleItem(
          productId: product.id!,
          saleId: 0,
          productName: product.name,
          quantity: 0,
          price: product.price,
        ),
      );

      if (existingItem.quantity == 0) {
        _cartItems.add(existingItem.copyWith(quantity: 1));
      } else {
        final index = _cartItems.indexOf(existingItem);
        _cartItems[index] = existingItem.copyWith(
          quantity: existingItem.quantity + 1,
        );
      }
    });
  }

  void _processSale() async {
    final totalAmount = _cartItems.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.price),
    );
    final newSale = Sale(
      date: DateTime.now().toIso8601String(),
      totalAmount: totalAmount,
    );

    await _saleService.addSale(newSale, _cartItems);

    setState(() {
      _cartItems = [];
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Venta procesada con éxito')));
  }

  void _showPaymentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Método de Pago'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.attach_money),
                title: const Text('Efectivo'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _processSale(); // Procesa la venta
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Tarjeta'),
                onTap: () {
                  Navigator.of(context).pop(); // Cierra el diálogo
                  _processSale(); // Procesa la venta
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ventas POS'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No hay productos disponibles.'),
                  );
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return InkWell(
                        onTap: () => _addToCart(product),
                        child: Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Carrito de Compras',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _cartItems.length,
                      itemBuilder: (context, index) {
                        final item = _cartItems[index];
                        return ListTile(
                          title: Text(item.productName),
                          subtitle: Text('Cantidad: ${item.quantity}'),
                          trailing: Text(
                            '\$${(item.quantity * item.price).toStringAsFixed(2)}',
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Total: \$${_cartItems.fold(0.0, (sum, item) => sum + (item.quantity * item.price)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: _cartItems.isEmpty
                          ? null
                          : _showPaymentDialog, // Llama al diálogo en lugar de procesar directamente
                      child: const Text('Procesar Venta'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension SaleItemExtension on SaleItem {
  SaleItem copyWith({
    int? id,
    int? saleId,
    int? productId,
    String? productName,
    int? quantity,
    double? price,
  }) {
    return SaleItem(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }
}
