import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, required this.onTap, super.key});

  final CheckedProduct product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = product.isSafe ? Colors.green : Colors.red;

    return Card(
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.15),
          foregroundColor: color,
          child: const Icon(Icons.inventory_2_outlined),
        ),
        title: Text(product.name),
        subtitle: Text(product.date),
        trailing: Text(
          product.verdict,
          style: TextStyle(color: color, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
