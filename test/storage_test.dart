import 'package:flutter_test/flutter_test.dart';
import 'package:foodcheck/data/products.dart';
import 'package:foodcheck/storage/storage_models.dart';

void main() {
  test('история проверки сохраняется и восстанавливается из записи БД', () {
    final source = products[2];
    final restored = ProductRecord.fromMap(ProductRecord(source).toMap())
        .product;

    expect(restored.name, source.name);
    expect(restored.barcode, source.barcode);
    expect(restored.isSafe, isFalse);
    expect(restored.dangerousComponents, contains('Орехи'));
    expect(restored.additives.single.code, 'E322');
  });

  test('профиль сохраняет список критических аллергенов', () {
    const source = ProfileData(
      name: 'Калинин В.М.',
      group: 'ИТИ-41',
      allergens: ['Орехи', 'Глютен'],
    );

    final restored = ProfileData.fromMap(source.toMap());

    expect(restored.name, source.name);
    expect(restored.group, source.group);
    expect(restored.allergens, source.allergens);
  });
}
