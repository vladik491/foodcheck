import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import 'barcode_scan_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String searchText = '';

  void openProduct(CheckedProduct product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => ProductDetailScreen(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleProducts = products
        .where(
          (product) =>
              product.name.toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('История проверок'),
        actions: [
          IconButton(
            key: const Key('scannerButton'),
            tooltip: 'Сканировать штрихкод',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const BarcodeScanScreen(),
                ),
              );
            },
            icon: const Icon(Icons.qr_code_scanner),
          ),
          IconButton(
            key: const Key('profileButton'),
            tooltip: 'Профиль',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const Icon(Icons.person_outline),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Проверенные продукты',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              key: const Key('historySearchField'),
              onChanged: (value) => setState(() => searchText = value),
              decoration: InputDecoration(
                hintText: 'Поиск по истории',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: visibleProducts.isEmpty
                  ? const Center(child: Text('Ничего не найдено'))
                  : ListView.separated(
                      itemCount: visibleProducts.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final product = visibleProducts[index];
                        return ProductCard(
                          product: product,
                          onTap: () => openProduct(product),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
