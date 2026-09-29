import 'package:flutter_test/flutter_test.dart';
import 'package:foodcheck/data/products.dart';
import 'package:foodcheck/services/product_check.dart';

void main() {
  final chocolate = productByBarcode('4601234567891')!;

  test('вердикт зависит от выбранных аллергенов', () {
    final safe = checkProduct(chocolate, ['Глютен']);
    final dangerous = checkProduct(chocolate, ['Орехи']);

    expect(safe.isSafe, isTrue);
    expect(safe.verdict, 'Безопасно');
    expect(matchingAllergens(safe, ['Глютен']), isEmpty);
    expect(dangerous.isSafe, isFalse);
    expect(matchingAllergens(dangerous, ['Орехи']), ['Орехи']);
  });

  test('новая проверка получает текущее время', () {
    final checked = checkProduct(chocolate, [
      'Орехи',
    ], checkedAt: DateTime(2026, 9, 29, 14, 7));

    expect(checked.date, '29.09.2026, 14:07');
    expect(checked.barcode, chocolate.barcode);
  });
}
