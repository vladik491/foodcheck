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

  @override
  void initState() {
    super.initState();
    AppStorage.instance.initialize().then((_) {
      if (!mounted) return;
      setState(() => profile = AppStorage.instance.profile);
    });
  }

  Future<void> saveAllergens(List<String> allergens) async {
    final updated = ProfileData(
      name: profile.name,
      group: profile.group,
      allergens: allergens,
    );
    setState(() => profile = updated);
    await AppStorage.instance.saveProfile(updated);
  }

  Future<void> addAllergen() async {
    final options = AppStorage.instance.availableAllergens
        .where((item) => !profile.allergens.contains(item))
        .toList();
    final selected = await showDialog<String>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Выбери аллерген'),
        children: options
            .map(
              (item) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, item),
                child: Text(item),
              ),
            )
            .toList(),
      ),
    );
    if (selected != null) {
      await saveAllergens([...profile.allergens, selected]);
    }
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
            children: profile.allergens
                .map(
                  (allergen) => InputChip(
                    key: Key('removeAllergen_$allergen'),
                    label: Text(allergen),
                    deleteIcon: Icon(
                      Icons.close,
                      key: Key('deleteAllergen_$allergen'),
                    ),
                    onDeleted: () => saveAllergens(
                      profile.allergens
                          .where((item) => item != allergen)
                          .toList(),
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed:
                  profile.allergens.length <
                      AppStorage.instance.availableAllergens.length
                  ? addAllergen
                  : null,
              icon: const Icon(Icons.add),
              label: const Text('Добавить аллерген'),
            ),
          ),
        ],
      ),
    );
  }
}
