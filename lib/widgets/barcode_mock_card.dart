import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class BarcodeMockCard extends StatelessWidget {
  const BarcodeMockCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  final CheckedProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SizedBox(
                key: Key('mockBarcode_${product.barcode}'),
                height: 72,
                width: double.infinity,
                child: BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: product.barcode,
                  drawText: false,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                product.barcode,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
