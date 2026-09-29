import 'package:flutter/material.dart';

import '../data/products.dart';
import '../models/product.dart';
import '../services/composition_analyzer.dart';
import '../services/open_food_facts_service.dart';
import '../storage/app_storage.dart';
import '../widgets/barcode_mock_card.dart';
import 'barcode_preview_screen.dart';
import 'camera_scan_screen.dart';
import 'composition_scan_screen.dart';
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
    final product =
        productByBarcode(barcode) ?? await fetchRemoteProduct(context, barcode);
    if (!context.mounted) return;
    if (product == null) {
      await openFallback(context, barcode);
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

  Future<CheckedProduct?> fetchRemoteProduct(
    BuildContext context,
    String barcode,
  ) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final service = OpenFoodFactsService();
    try {
      return await service.fetchProduct(barcode);
    } catch (_) {
      return null;
    } finally {
      service.close();
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  Future<void> openFallback(BuildContext context, String barcode) async {
    if (!context.mounted) return;
    final useText = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Товар не найден'),
        content: const Text(
          'В базе Open Food Facts нет записи или отсутствует интернет. Можно проверить состав с упаковки.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Сканировать состав'),
          ),
        ],
      ),
    );
    if (useText != true || !context.mounted) return;

    final composition = await Navigator.of(context).push<String>(
      MaterialPageRoute(builder: (context) => const CompositionScanScreen()),
    );
    if (composition == null || !context.mounted) return;

    await AppStorage.instance.initialize();
    final product = CompositionAnalyzer.createProduct(
      text: composition,
      barcode: barcode,
      registryMarkers: AppStorage.instance.availableAllergens,
    );
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
