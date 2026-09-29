import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class OpenFoodFactsService {
  OpenFoodFactsService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<CheckedProduct?> fetchProduct(String barcode) async {
    final uri = Uri.https(
      'world.openfoodfacts.org',
      '/api/v2/product/$barcode',
      {
        'fields': 'code,product_name,product_name_ru,brands,ingredients_text,ingredients_text_ru,allergens,allergens_tags,additives_tags,additives_original_tags,additives_names',
      },
    );

    final response = await _client
        .get(uri, headers: {'User-Agent': 'FoodCheck/1.0'})
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200) return null;

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> || body['status'] != 1) return null;
    final product = body['product'];
    if (product is! Map<String, dynamic>) return null;
    return parseProduct(product, barcode);
  }

  static CheckedProduct? parseProduct(
    Map<String, dynamic> product,
    String barcode,
  ) {
    final name = _firstText([
      product['product_name_ru'],
      product['product_name'],
      product['brands'],
    ]);
    if (name == null || name.isEmpty) return null;

    final composition =
        _firstText([
          product['ingredients_text_ru'],
          product['ingredients_text'],
        ]) ??
        'Состав не указан';
    final allergens = _findAllergens(product, composition);
    final additives = _findAdditives(product);

    return CheckedProduct(
      name: name,
      date: '',
      verdict: 'Безопасно',
      isSafe: true,
      barcode: _firstText([product['code'], barcode])!,
      composition: composition,
      dangerousComponents: allergens,
      additives: additives,
    );
  }

  static String? _firstText(Iterable<Object?> values) {
    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  static List<String> _findAllergens(
    Map<String, dynamic> product,
    String composition,
  ) {
    final result = <String>{};
    final tags = _strings(product['allergens_tags']);
    for (final tag in tags) {
      final marker = _allergenFromText(tag);
      if (marker != null) result.add(marker);
    }
    final text = '${product['allergens'] ?? ''} $composition'.toLowerCase();
    for (final word in const ['орех', 'nuts', 'nut', 'арахис', 'peanut']) {
      if (text.contains(word)) result.add('Орехи');
    }
    for (final word in const ['лактоз', 'молоч', 'milk', 'lactose']) {
      if (text.contains(word)) result.add('Лактоза');
    }
    for (final word in const ['глютен', 'пшен', 'рож', 'gluten', 'wheat']) {
      if (text.contains(word)) result.add('Глютен');
    }
    for (final word in const ['яйц', 'egg']) {
      if (text.contains(word)) result.add('Яйца');
    }
    for (final word in const ['соя', 'soy']) {
      if (text.contains(word)) result.add('Соя');
    }
    for (final word in const ['рыб', 'fish']) {
      if (text.contains(word)) result.add('Рыба');
    }
    for (final word in const ['моллюск', 'shellfish']) {
      if (text.contains(word)) result.add('Моллюски');
    }
    for (final word in const ['кунжут', 'sesame']) {
      if (text.contains(word)) result.add('Кунжут');
    }
    for (final word in const ['горчиц', 'mustard']) {
      if (text.contains(word)) result.add('Горчица');
    }
    for (final word in const ['сельдер', 'celery']) {
      if (text.contains(word)) result.add('Сельдерей');
    }
    for (final word in const ['сульфит', 'sulfite']) {
      if (text.contains(word)) result.add('Сульфиты');
    }
    return result.toList();
  }

  static String? _allergenFromText(String value) {
    final text = value.toLowerCase();
    if (text.contains('nut') ||
        text.contains('арахис') ||
        text.contains('орех')) {
      return 'Орехи';
    }
    if (text.contains('milk') ||
        text.contains('lactose') ||
        text.contains('молоч')) {
      return 'Лактоза';
    }
    if (text.contains('gluten') ||
        text.contains('wheat') ||
        text.contains('глютен')) {
      return 'Глютен';
    }
    if (text.contains('egg') || text.contains('яйц')) return 'Яйца';
    if (text.contains('soy') || text.contains('соя')) return 'Соя';
    if (text.contains('fish') || text.contains('рыб')) return 'Рыба';
    if (text.contains('shellfish') || text.contains('моллюск')) {
      return 'Моллюски';
    }
    if (text.contains('sesame') || text.contains('кунжут')) return 'Кунжут';
    if (text.contains('mustard') || text.contains('горчиц')) return 'Горчица';
    if (text.contains('celery') || text.contains('сельдер')) return 'Сельдерей';
    if (text.contains('sulfite') || text.contains('сульфит')) return 'Сульфиты';
    return null;
  }

  static List<Additive> _findAdditives(Map<String, dynamic> product) {
    final names = product['additives_names'];
    final result = <Additive>[];
    final tags = [
      ..._strings(product['additives_tags']),
      ..._strings(product['additives_original_tags']),
    ];
    final codes = <String>{};
    for (final tag in tags) {
      final match = RegExp(r'e\d{3,4}', caseSensitive: false).firstMatch(tag);
      if (match != null) codes.add(match.group(0)!.toUpperCase());
    }
    for (final code in codes) {
      final name = names is Map<String, dynamic>
          ? _firstText([names['en:$code'.toLowerCase()], names[code]])
          : null;
      result.add(
        Additive(
          code: code,
          name: name ?? 'добавка',
          description: 'Информация получена из Open Food Facts',
        ),
      );
    }
    return result;
  }

  static List<String> _strings(Object? value) {
    if (value is List) return value.whereType<String>().toList();
    if (value is String && value.isNotEmpty) return [value];
    return [];
  }

  void close() => _client.close();
}
