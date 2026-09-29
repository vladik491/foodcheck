import 'dart:convert';

import '../models/product.dart';

class ProfileData {
  const ProfileData({
    required this.name,
    required this.group,
    required this.allergens,
  });

  final String name;
  final String group;
  final List<String> allergens;

  factory ProfileData.fromMap(Map<String, Object?> map) {
    return ProfileData(
      name: map['name'] as String? ?? 'Калинин В.М.',
      group: map['group_name'] as String? ?? 'ИТИ-41',
      allergens: decodeStringList(map['allergens'] as String?),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': 1,
      'name': name,
      'group_name': group,
      'allergens': jsonEncode(allergens),
    };
  }
}

class ProductRecord {
  const ProductRecord(this.product);

  final CheckedProduct product;

  factory ProductRecord.fromMap(Map<String, Object?> map) {
    final additives = (jsonDecode(map['additives'] as String) as List)
        .map(
          (item) => Additive(
            code: item['code'] as String,
            name: item['name'] as String,
            description: item['description'] as String,
          ),
        )
        .toList();

    return ProductRecord(
      CheckedProduct(
        name: map['name'] as String,
        date: map['checked_at'] as String,
        verdict: map['verdict'] as String,
        isSafe: (map['is_safe'] as int) == 1,
        barcode: map['barcode'] as String,
        composition: map['composition'] as String,
        dangerousComponents: decodeStringList(
          map['dangerous_components'] as String?,
        ),
        additives: additives,
      ),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'name': product.name,
      'checked_at': product.date,
      'verdict': product.verdict,
      'is_safe': product.isSafe ? 1 : 0,
      'barcode': product.barcode,
      'composition': product.composition,
      'dangerous_components': jsonEncode(product.dangerousComponents),
      'additives': jsonEncode(
        product.additives
            .map(
              (item) => {
                'code': item.code,
                'name': item.name,
                'description': item.description,
              },
            )
            .toList(),
      ),
    };
  }
}

List<String> decodeStringList(String? value) {
  if (value == null || value.isEmpty) return [];
  return (jsonDecode(value) as List).cast<String>();
}
