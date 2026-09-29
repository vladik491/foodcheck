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
    final known = _realm!
        .all<HarmfulComponent>()
        .map((item) => item.id)
        .toSet();
    final missing = defaultComponents.where((item) => !known.contains(item.id));
    if (missing.isNotEmpty) {
      _realm!.write(() {
        for (final item in missing) {
          _realm!.add(
            HarmfulComponent(
              item.id,
              item.marker,
              item.description,
              item.risk,
            ),
          );
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
  HarmfulComponent(
    'eggs',
    'Яйца',
    'Пищевой аллерген, встречается в выпечке и соусах',
    'Высокий',
  ),
  HarmfulComponent(
    'soy',
    'Соя',
    'Растительный белок и распространённый пищевой аллерген',
    'Высокий',
  ),
  HarmfulComponent(
    'fish',
    'Рыба',
    'Аллерген, встречается в рыбных продуктах и соусах',
    'Высокий',
  ),
  HarmfulComponent(
    'shellfish',
    'Моллюски',
    'Аллерген морепродуктов',
    'Высокий',
  ),
  HarmfulComponent(
    'sesame',
    'Кунжут',
    'Пищевой аллерген, встречается в хлебе и кондитерских изделиях',
    'Средний',
  ),
  HarmfulComponent(
    'mustard',
    'Горчица',
    'Пищевой аллерген, встречается в соусах и приправах',
    'Средний',
  ),
  HarmfulComponent(
    'celery',
    'Сельдерей',
    'Пищевой аллерген, встречается в приправах и супах',
    'Средний',
  ),
  HarmfulComponent(
    'sulfites',
    'Сульфиты',
    'Консерванты, которые могут вызывать реакцию у чувствительных людей',
    'Средний',
  ),
];
