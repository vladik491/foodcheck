import 'package:flutter/material.dart';

import '../storage/app_storage.dart';
import '../storage/storage_models.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileData profile = AppStorage.instance.profile;
  final availableAllergens = const ['Орехи', 'Лактоза', 'Глютен'];

  @override
  void initState() {
    super.initState();
    AppStorage.instance.initialize().then((_) {
      if (!mounted) return;
      setState(() => profile = AppStorage.instance.profile);
    });
  }

  Future<void> changeAllergen(String allergen, bool selected) async {
    final allergens = {...profile.allergens};
    if (selected) {
      allergens.add(allergen);
    } else {
      allergens.remove(allergen);
    }
    final updated = ProfileData(
      name: profile.name,
      group: profile.group,
      allergens: availableAllergens
          .where(allergens.contains)
          .toList(growable: false),
    );
    setState(() => profile = updated);
    await AppStorage.instance.saveProfile(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(child: Icon(Icons.person_outline)),
            title: Text(profile.name),
            subtitle: Text('Группа ${profile.group}'),
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
            children: availableAllergens
                .map(
                  (allergen) => FilterChip(
                    label: Text(allergen),
                    selected: profile.allergens.contains(allergen),
                    onSelected: (selected) =>
                        changeAllergen(allergen, selected),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
