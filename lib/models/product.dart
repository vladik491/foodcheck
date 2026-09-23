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
