import 'package:flutter_test/flutter_test.dart';
import 'package:foodcheck/services/composition_analyzer.dart';
import 'package:foodcheck/services/open_food_facts_service.dart';

void main() {
  test('ответ Open Food Facts преобразуется в продукт', () {
    final product = OpenFoodFactsService.parseProduct({
      'product_name_ru': 'Тестовый батончик',
      'ingredients_text_ru': 'сахар, молоко, орехи',
      'allergens_tags': ['en:milk', 'en:nuts'],
      'additives_tags': ['en:e322'],
      'code': '1234567890123',
    }, '1234567890123');

    expect(product, isNotNull);
    expect(product!.name, 'Тестовый батончик');
    expect(product.dangerousComponents, containsAll(['Лактоза', 'Орехи']));
    expect(product.additives.single.code, 'E322');
  });

  test('текст состава сопоставляется с медицинским реестром', () {
    final product = CompositionAnalyzer.createProduct(
      text: 'мука пшеничная, молоко, E322',
      barcode: 'unknown',
      registryMarkers: const ['Орехи', 'Лактоза', 'Глютен', 'E322'],
    );

    expect(product.dangerousComponents, containsAll(['Лактоза', 'Глютен']));
    expect(product.additives.single.code, 'E322');
  });
}
