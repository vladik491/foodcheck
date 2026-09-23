import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text('Калинин В.М.'),
            subtitle: Text('Группа ИТИ-41'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Критические аллергены',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('Эти компоненты будут отмечаться при проверке продукта.'),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: const [
              Chip(label: Text('Орехи')),
              Chip(label: Text('Лактоза')),
              Chip(label: Text('Глютен')),
            ],
          ),
        ],
      ),
    );
  }
}
