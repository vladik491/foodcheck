import '../data/products.dart';
import '../models/product.dart';
import 'local_database.dart';
import 'medical_registry.dart';
import 'storage_models.dart';

class AppStorage {
  AppStorage._();

  static final instance = AppStorage._();

  List<CheckedProduct> checkedProducts = List.of(products);
  ProfileData profile = const ProfileData(
    name: 'Калинин В.М.',
    group: 'ИТИ-41',
    allergens: ['Орехи', 'Лактоза', 'Глютен'],
  );

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

  Future<void> saveProfile(ProfileData value) async {
    profile = value;
    try {
      await _database?.saveProfile(value);
    } catch (_) {}
  }
}
