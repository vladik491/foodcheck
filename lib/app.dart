import 'package:flutter/material.dart';

import 'screens/history_screen.dart';

class FoodCheckApp extends StatelessWidget {
  const FoodCheckApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Проверка продуктов',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HistoryScreen(),
    );
  }
}
