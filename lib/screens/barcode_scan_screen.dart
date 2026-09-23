import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../widgets/barcode_mock_card.dart';
import 'product_detail_screen.dart';

class BarcodeScanScreen extends StatelessWidget {
  const BarcodeScanScreen({super.key});

  void openProduct(BuildContext context, CheckedProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scanProducts = [
      products[0],
      products[2],
      products[3],
      products[4],
      products[5],
    ];

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
          ...scanProducts.map(
            (product) => BarcodeMockCard(
              product: product,
              onTap: () => openProduct(context, product),
            ),
          ),
        ],
      ),
    );
  }
}
