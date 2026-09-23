import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.product, super.key});

  final CheckedProduct product;

  @override
  Widget build(BuildContext context) {
    final verdictColor = product.isSafe ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: verdictColor.withValues(alpha: 0.12),
            child: ListTile(
              leading: Icon(
                product.isSafe ? Icons.check_circle : Icons.warning,
                color: verdictColor,
              ),
              title: const Text('Итог проверки'),
              subtitle: Text(
                product.verdict,
                style: TextStyle(
                  color: verdictColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Состав продукта',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(product.composition),
          if (product.dangerousComponents.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Опасные компоненты',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: product.dangerousComponents
                  .map(
                    (component) => Chip(
                      avatar: const Icon(Icons.warning_amber, size: 18),
                      backgroundColor: Colors.red.shade100,
                      label: Text(component),
                    ),
                  )
                  .toList(),
            ),
          ],
          const SizedBox(height: 20),
          const Text(
            'E-добавки',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          if (product.additives.isEmpty)
            const Text('E-добавки не обнаружены')
          else
            ...product.additives.map(
              (additive) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.info_outline),
                title: Text(additive.title),
                subtitle: Text(additive.description),
              ),
            ),
          const SizedBox(height: 12),
          Text(
            'Штрихкод: ${product.barcode}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
