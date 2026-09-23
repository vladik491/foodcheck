import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:foodcheck/main.dart';

void main() {
  testWidgets('поиск фильтрует историю проверок', (tester) async {
    await tester.pumpWidget(const FoodCheckApp());

    expect(find.text('Молоко Простоквашино'), findsOneWidget);
    expect(find.text('Шоколад Алёнка'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('historySearchField')),
      'шоколад',
    );
    await tester.pump();

    expect(find.text('Шоколад Алёнка'), findsOneWidget);
    expect(find.text('Молоко Простоквашино'), findsNothing);
  });

  testWidgets('кнопка профиля открывает экран профиля', (tester) async {
    await tester.pumpWidget(const FoodCheckApp());

    await tester.tap(find.byKey(const Key('profileButton')));
    await tester.pumpAndSettle();

    expect(find.text('Профиль'), findsOneWidget);
    expect(find.text('Критические аллергены'), findsOneWidget);
    expect(find.text('Орехи'), findsOneWidget);
  });

  testWidgets('нажатие на продукт открывает подробную информацию', (
    tester,
  ) async {
    await tester.pumpWidget(const FoodCheckApp());

    await tester.tap(find.text('Шоколад Алёнка'));
    await tester.pumpAndSettle();

    expect(find.text('Состав продукта'), findsOneWidget);
    expect(find.text('Противопоказано'), findsOneWidget);
    expect(find.text('E322 - лецитин'), findsOneWidget);
    expect(find.text('Орехи'), findsOneWidget);
  });

  testWidgets('расширенная история прокручивается до новых продуктов', (
    tester,
  ) async {
    await tester.pumpWidget(const FoodCheckApp());

    expect(find.text('Кефир Домик в деревне'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0, -700));
    await tester.pump();

    expect(find.text('Кефир Домик в деревне'), findsOneWidget);
  });

  testWidgets('кнопка открывает экран выбора штрихкода', (tester) async {
    await tester.pumpWidget(const FoodCheckApp());

    await tester.tap(find.byKey(const Key('scannerButton')));
    await tester.pumpAndSettle();

    expect(find.text('Сканирование штрихкода'), findsOneWidget);
    expect(find.byKey(const Key('mockBarcode_4601234567890')), findsOneWidget);
    expect(find.byKey(const Key('mockBarcode_4601234567891')), findsOneWidget);
  });

  testWidgets('выбор изображения штрихкода открывает товар', (tester) async {
    await tester.pumpWidget(const FoodCheckApp());

    await tester.tap(find.byKey(const Key('scannerButton')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mockBarcode_4601234567891')));
    await tester.pumpAndSettle();

    expect(find.text('Шоколад Алёнка'), findsOneWidget);
    expect(find.text('Противопоказано'), findsOneWidget);
  });

  testWidgets('товар из истории доступен в списке штрихкодов', (tester) async {
    await tester.pumpWidget(const FoodCheckApp());

    await tester.tap(find.byKey(const Key('scannerButton')));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('mockBarcode_4601234567899')),
      500,
    );

    expect(find.byKey(const Key('mockBarcode_4601234567899')), findsOneWidget);
  });
}
