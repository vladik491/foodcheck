import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/product.dart';
import 'storage_models.dart';

class LocalDatabase {
  Database? _database;

  Future<Database> open() async {
    if (_database != null) return _database!;

    final databasePath = join(await getDatabasesPath(), 'foodcheck.db');
    _database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            group_name TEXT NOT NULL,
            allergens TEXT NOT NULL
          )
        ''');
        await database.execute('''
          CREATE TABLE checked_products (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            checked_at TEXT NOT NULL,
            verdict TEXT NOT NULL,
            is_safe INTEGER NOT NULL,
            barcode TEXT NOT NULL UNIQUE,
            composition TEXT NOT NULL,
            dangerous_components TEXT NOT NULL,
            additives TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }

  Future<List<CheckedProduct>> readProducts() async {
    final database = await open();
    final rows = await database.query('checked_products', orderBy: 'id ASC');
    return rows
        .map(ProductRecord.fromMap)
        .map((record) => record.product)
        .toList();
  }

  Future<void> saveProducts(List<CheckedProduct> values) async {
    final database = await open();
    await database.transaction((transaction) async {
      for (final product in values) {
        await transaction.insert(
          'checked_products',
          ProductRecord(product).toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<ProfileData?> readProfile() async {
    final database = await open();
    final rows = await database.query(
      'profile',
      where: 'id = ?',
      whereArgs: [1],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ProfileData.fromMap(rows.first);
  }

  Future<void> saveProfile(ProfileData profile) async {
    final database = await open();
    await database.insert(
      'profile',
      profile.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
