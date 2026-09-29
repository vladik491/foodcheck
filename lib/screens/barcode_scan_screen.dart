import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../storage/app_storage.dart';
import '../widgets/barcode_mock_card.dart';
import 'barcode_preview_screen.dart';
import 'camera_scan_screen.dart';
import 'product_detail_screen.dart';

class BarcodeScanScreen extends StatelessWidget {
  const BarcodeScanScreen({required this.items, super.key});

  final List<CheckedProduct> items;

  Future<void> scanWithCamera(BuildContext context) async {
    final barcode = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const CameraScanScreen()),
    );
    if (barcode != null && context.mounted) {
      openBarcode(context, barcode);
    }
  }

  Future<void> openBarcode(BuildContext context, String barcode) async {
    final product = productByBarcode(barcode);
    if (product == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Товар с таким штрихкодом не найден')),
      );
      return;
    }

    final checked = await AppStorage.instance.recordCheck(product);
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(product: checked),
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
          ...items.map(
            (product) => BarcodeMockCard(
              product: product,
              onTap: () => openBarcode(context, product.barcode),
              onPreview: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => BarcodePreviewScreen(product: product),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
