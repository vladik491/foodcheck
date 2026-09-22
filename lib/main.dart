import 'package:flutter/material.dart';

void main() {
  runApp(const FoodCheckApp());
}

class FoodCheckApp extends StatelessWidget {
  const FoodCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проверка продуктов',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HistoryScreen(),
    );
  }
}

class CheckedProduct {
  const CheckedProduct({
    required this.name,
    required this.date,
    required this.verdict,
    required this.isSafe,
  });

  final String name;
  final String date;
  final String verdict;
  final bool isSafe;
}

const products = [
  CheckedProduct(
    name: 'Молоко Простоквашино',
    date: 'Сегодня, 10:25',
    verdict: 'Безопасно',
    isSafe: true,
  ),
  CheckedProduct(
    name: 'Шоколад Алёнка',
    date: 'Вчера, 18:40',
    verdict: 'Есть замечания',
    isSafe: false,
  ),
  CheckedProduct(
    name: 'Йогурт Активиа',
    date: '12 марта, 09:15',
    verdict: 'Безопасно',
    isSafe: true,
  ),
];

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String searchText = '';

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
                        return ProductCard(product: visibleProducts[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  const ProductCard({required this.product, super.key});

  final CheckedProduct product;

  @override
  Widget build(BuildContext context) {
    final color = product.isSafe ? Colors.green : Colors.orange;

    return Card(
      child: ListTile(
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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Критические аллергены',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Эти компоненты будут отмечаться при проверке продукта.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Орехи')),
              Chip(label: Text('Лактоза')),
              Chip(label: Text('Глютен')),
            ],
          ),
        ],
      ),
    );
  }
}
