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

class Additive {
  const Additive({
    required this.code,
    required this.name,
    required this.description,
  });

  final String code;
  final String name;
  final String description;

  String get title => '$code - $name';
}

class CheckedProduct {
  const CheckedProduct({
    required this.name,
    required this.date,
    required this.verdict,
    required this.isSafe,
    required this.barcode,
    required this.composition,
    required this.dangerousComponents,
    required this.additives,
  });

  final String name;
  final String date;
  final String verdict;
  final bool isSafe;
  final String barcode;
  final String composition;
  final List<String> dangerousComponents;
  final List<Additive> additives;
}

const products = [
  CheckedProduct(
    name: 'Молоко Простоквашино',
    date: 'Сегодня, 10:25',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567890',
    composition: 'молоко нормализованное',
    dangerousComponents: [],
    additives: [],
  ),
  CheckedProduct(
    name: 'Йогурт Активиа',
    date: '12 марта, 09:15',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567892',
    composition: 'молоко, закваска, сахар, фруктовый наполнитель',
    dangerousComponents: [],
    additives: [
      Additive(
        code: 'E440',
        name: 'пектин',
        description: 'загуститель растительного происхождения',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Шоколад Алёнка',
    date: 'Вчера, 18:40',
    verdict: 'Противопоказано',
    isSafe: false,
    barcode: '4601234567891',
    composition: 'сахар, какао-масло, сухое молоко, орехи',
    dangerousComponents: ['Лактоза', 'Орехи'],
    additives: [
      Additive(
        code: 'E322',
        name: 'лецитин',
        description: 'эмульгатор для смешивания компонентов продукта',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Сок яблочный',
    date: '8 марта, 13:05',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567894',
    composition: 'яблочный сок, вода',
    dangerousComponents: [],
    additives: [
      Additive(
        code: 'E300',
        name: 'аскорбиновая кислота',
        description: 'антиоксидант, известный как витамин C',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Хлеб Бородинский',
    date: '10 марта, 16:20',
    verdict: 'Противопоказано',
    isSafe: false,
    barcode: '4601234567893',
    composition: 'мука ржаная, мука пшеничная, вода, солод',
    dangerousComponents: ['Глютен'],
    additives: [
      Additive(
        code: 'E282',
        name: 'пропионат кальция',
        description: 'консервант для сохранения свежести хлеба',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Чипсы картофельные',
    date: '5 марта, 20:10',
    verdict: 'Противопоказано',
    isSafe: false,
    barcode: '4601234567895',
    composition: 'картофель, растительное масло, соль, ароматизатор',
    dangerousComponents: ['Глютен'],
    additives: [
      Additive(
        code: 'E621',
        name: 'глутамат натрия',
        description: 'усилитель вкуса и аромата',
      ),
      Additive(
        code: 'E627',
        name: 'гуанилат натрия',
        description: 'усилитель вкуса',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Творог Простоквашино',
    date: '3 марта, 11:40',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567896',
    composition: 'молоко, закваска',
    dangerousComponents: [],
    additives: [],
  ),
  CheckedProduct(
    name: 'Каша гречневая',
    date: '1 марта, 08:30',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567897',
    composition: 'крупа гречневая, вода, соль',
    dangerousComponents: [],
    additives: [],
  ),
  CheckedProduct(
    name: 'Батон нарезной',
    date: '27 февраля, 17:15',
    verdict: 'Противопоказано',
    isSafe: false,
    barcode: '4601234567898',
    composition: 'мука пшеничная, вода, дрожжи, сахар, соль',
    dangerousComponents: ['Глютен'],
    additives: [
      Additive(
        code: 'E282',
        name: 'пропионат кальция',
        description: 'консервант для сохранения свежести хлеба',
      ),
    ],
  ),
  CheckedProduct(
    name: 'Кефир Домик в деревне',
    date: '25 февраля, 19:05',
    verdict: 'Безопасно',
    isSafe: true,
    barcode: '4601234567899',
    composition: 'молоко, закваска',
    dangerousComponents: [],
    additives: [
      Additive(
        code: 'E202',
        name: 'сорбат калия',
        description: 'консервант для сохранения продукта',
      ),
    ],
  ),
];

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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text('Калинин В.М.'),
            subtitle: Text('Группа ИТИ-41'),
          ),
          const SizedBox(height: 16),
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
