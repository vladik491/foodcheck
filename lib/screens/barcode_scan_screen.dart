import 'package:flutter/material.dart';

import '../data/products.dart';
import '../widgets/barcode_mock_card.dart';
import 'product_detail_screen.dart';

class BarcodeScanScreen extends StatelessWidget {
  const BarcodeScanScreen({super.key});

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
          const Text(
            'Выберите изображение штрихкода',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'На эмуляторе выбор изображения заменяет наведение камеры на упаковку товара.',
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
