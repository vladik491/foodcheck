import 'package:realm/realm.dart';

part 'medical_registry.realm.dart';

@RealmModel()
class _HarmfulComponent {
  @PrimaryKey()
  late String id;

  late String marker;
  late String description;
  late String risk;
}

class MedicalRegistry {
  Realm? _realm;

  void open() {
    if (_realm != null) return;

    final configuration = Configuration.local([HarmfulComponent.schema]);
    _realm = Realm(configuration);
    if (_realm!.all<HarmfulComponent>().isEmpty) {
      _realm!.write(() {
        for (final item in defaultComponents) {
          _realm!.add(item);
        }
      });
    }
  }

  List<HarmfulComponent> get components =>
      _realm?.all<HarmfulComponent>().toList() ?? [];

  void close() {
    _realm?.close();
    _realm = null;
  }
}

final defaultComponents = [
  HarmfulComponent(
    'E322',
    'E322',
    'Лецитин, эмульгатор для смешивания компонентов продукта',
    'Средний',
  ),
  HarmfulComponent(
    'lactose',
    'Лактоза',
    'Молочный сахар, который может вызывать реакцию при непереносимости',
    'Высокий',
  ),
  HarmfulComponent(
    'nuts',
    'Орехи',
    'Распространённый пищевой аллерген',
    'Высокий',
  ),
  HarmfulComponent(
    'gluten',
    'Глютен',
    'Белок злаковых культур, важный для контроля при непереносимости',
    'Высокий',
  ),
];
