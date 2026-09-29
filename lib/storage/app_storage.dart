import '../data/products.dart';
import '../models/product.dart';
import '../services/product_check.dart';
import 'local_database.dart';
import 'medical_registry.dart';
import 'storage_models.dart';

class AppStorage {
  AppStorage._();

  static final instance = AppStorage._();

  static const defaultProfile = ProfileData(
    name: 'Калинин В.М.',
    group: 'ИТИ-41',
    allergens: ['Орехи', 'Лактоза', 'Глютен'],
  );

  List<CheckedProduct> checkedProducts = List.of(products);
  ProfileData profile = defaultProfile;

  LocalDatabase? _database;
  MedicalRegistry? _registry;
  Future<void>? _initialization;

  Future<void> initialize() {
    return _initialization ??= _loadData();
  }

  Future<void> _loadData() async {
    try {
      _database = LocalDatabase();
      final savedProducts = await _database!.readProducts();
      if (savedProducts.isEmpty) {
        await _database!.saveProducts(products);
      } else {
        checkedProducts = savedProducts;
      }

      final savedProfile = await _database!.readProfile();
      if (savedProfile == null) {
        await _database!.saveProfile(profile);
      } else {
        profile = savedProfile;
      }
    } catch (_) {
      checkedProducts = List.of(products);
    }

    try {
      _registry = MedicalRegistry()..open();
    } catch (_) {
      _registry = null;
    }
  }

  MedicalRegistry? get medicalRegistry => _registry;

  List<String> get availableAllergens {
    final fromRegistry = _registry?.components
        .where((item) => !item.marker.startsWith('E'))
        .map((item) => item.marker)
        .toList();
    return fromRegistry == null || fromRegistry.isEmpty
        ? ['Орехи', 'Лактоза', 'Глютен']
        : fromRegistry;
  }

  Future<CheckedProduct> recordCheck(CheckedProduct product) async {
    await initialize();
    final checked = checkProduct(
      product,
      profile.allergens,
      checkedAt: DateTime.now(),
    );
    checkedProducts.insert(0, checked);
    try {
      await _database?.insertProduct(checked);
    } catch (_) {}
    return checked;
  }

  Future<void> saveProfile(ProfileData value) async {
    profile = value;
    try {
      await _database?.saveProfile(value);
    } catch (_) {}
  }

  Future<void> resetForTesting() async {
    await _database?.close();
    _database = null;
    _registry?.close();
    _registry = null;
    _initialization = Future.value();
    checkedProducts = List.of(products);
    profile = defaultProfile;
  }
}
