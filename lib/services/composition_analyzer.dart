import '../models/product.dart';

class CompositionAnalyzer {
  static CheckedProduct createProduct({
    required String text,
    required String barcode,
    required Iterable<String> registryMarkers,
  }) {
    final lowerText = text.toLowerCase();
    final dangerous = <String>[];
    for (final marker in registryMarkers) {
      final words = _wordsFor(marker);
      if (words.any(lowerText.contains)) dangerous.add(marker);
    }

    final additives = <Additive>[];
    final codes = RegExp(r'\b[EЕ]\s?-?\d{3,4}\b', caseSensitive: false)
        .allMatches(text)
        .map((match) => match.group(0)!.replaceAll(RegExp(r'[^0-9]'), ''))
        .map((value) => 'E$value')
        .toSet();
    for (final code in codes) {
      additives.add(
        Additive(
          code: code,
          name: 'добавка',
          description: 'Найдена при распознавании состава',
        ),
      );
    }

    return CheckedProduct(
      name: 'Проверка состава',
      date: '',
      verdict: 'Безопасно',
      isSafe: true,
      barcode: barcode,
      composition: text,
      dangerousComponents: dangerous,
      additives: additives,
    );
  }

  static List<String> _wordsFor(String marker) {
    switch (marker.toLowerCase()) {
      case 'орехи':
        return ['орех', 'nuts', 'nut', 'арахис', 'peanut'];
      case 'лактоза':
        return ['лактоз', 'молок', 'молоч', 'milk', 'lactose'];
      case 'глютен':
        return ['глютен', 'пшен', 'рож', 'мук', 'gluten', 'wheat'];
      case 'яйца':
        return ['яйц', 'egg'];
      case 'соя':
        return ['соя', 'soy'];
      case 'рыба':
        return ['рыб', 'fish'];
      case 'моллюски':
        return ['моллюск', 'shellfish'];
      case 'кунжут':
        return ['кунжут', 'sesame'];
      case 'горчица':
        return ['горчиц', 'mustard'];
      case 'сельдерей':
        return ['сельдер', 'celery'];
      case 'сульфиты':
        return ['сульфит', 'sulfite'];
      default:
        return [marker.toLowerCase()];
    }
  }
}
