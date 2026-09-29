import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class BarcodePreviewScreen extends StatelessWidget {
  const BarcodePreviewScreen({required this.product, super.key});

  final CheckedProduct product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Штрихкод товара')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Наведите камеру другого телефона на этот экран.'),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: product.barcode,
                  height: 180,
                  drawText: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
