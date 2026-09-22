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
}
