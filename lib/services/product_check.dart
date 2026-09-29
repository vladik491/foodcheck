import '../models/product.dart';

List<String> matchingAllergens(
  CheckedProduct product,
  List<String> selectedAllergens,
) {
  return product.dangerousComponents.where(selectedAllergens.contains).toList();
}

CheckedProduct checkProduct(
  CheckedProduct product,
  List<String> selectedAllergens, {
  DateTime? checkedAt,
}) {
  final isSafe = matchingAllergens(product, selectedAllergens).isEmpty;
  final time = checkedAt;
  final date = time == null
      ? product.date
      : '${time.day.toString().padLeft(2, '0')}.'
            '${time.month.toString().padLeft(2, '0')}.'
            '${time.year}, '
            '${time.hour.toString().padLeft(2, '0')}:'
            '${time.minute.toString().padLeft(2, '0')}';

  return CheckedProduct(
    name: product.name,
    date: date,
    verdict: isSafe ? 'Безопасно' : 'Противопоказано',
    isSafe: isSafe,
    barcode: product.barcode,
    composition: product.composition,
    dangerousComponents: product.dangerousComponents,
    additives: product.additives,
  );
}
