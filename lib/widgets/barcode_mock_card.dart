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
                child: CustomPaint(painter: BarcodePainter(product.barcode)),
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

class BarcodePainter extends CustomPainter {
  BarcodePainter(this.code);

  final String code;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black87;
    var x = 4.0;
    var index = 0;

    while (x < size.width - 4) {
      final digit = code.codeUnitAt(index % code.length) - 48;
      final barWidth = 1.5 + (digit % 3);
      final gap = 1.0 + ((digit + index) % 2);
      final top = index % 5 == 0 ? 8.0 : 3.0;
      final bottom = index % 5 == 0 ? size.height - 8 : size.height - 3;

      canvas.drawRect(Rect.fromLTWH(x, top, barWidth, bottom - top), paint);
      x += barWidth + gap;
      index++;
    }
  }

  @override
  bool shouldRepaint(covariant BarcodePainter oldDelegate) {
    return oldDelegate.code != code;
  }
}
