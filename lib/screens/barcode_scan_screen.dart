import 'package:flutter/material.dart';

import '../data/products.dart';
import '../widgets/barcode_mock_card.dart';
import 'camera_scan_screen.dart';
import 'product_detail_screen.dart';

class BarcodeScanScreen extends StatelessWidget {
  const BarcodeScanScreen({super.key});

  Future<void> scanWithCamera(BuildContext context) async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const CameraScanScreen()),
    );
    if (barcode != null && context.mounted) {
      openBarcode(context, barcode);
    }
  }

  void openBarcode(BuildContext context, String barcode) {
    final product = productByBarcode(barcode);
    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар с таким штрихкодом не найден')),
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Сканирование штрихкода')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FilledButton.icon(
            onPressed: () => scanWithCamera(context),
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Сканировать камерой'),
          ),
          const SizedBox(height: 20),
          const Text(
            'Демонстрационные штрихкоды',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'На эмуляторе можно выбрать штрихкод из списка. На телефоне его можно считать камерой с экрана другого устройства.',
          ),
          const SizedBox(height: 16),
          ...products.map(
            (product) => BarcodeMockCard(
              product: product,
              onTap: () => openBarcode(context, product.barcode),
            ),
          ),
        ],
      ),
    );
  }
}
