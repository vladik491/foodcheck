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
      version: 2,
      onCreate: (database, version) async {
        await database.execute('''
          CREATE TABLE profile (
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            group_name TEXT NOT NULL,
            allergens TEXT NOT NULL
          )
        ''');
        await _createHistoryTable(database);
      },
      onUpgrade: (database, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await database.execute(
            'ALTER TABLE checked_products RENAME TO old_checked_products',
          );
          await _createHistoryTable(database);
          await database.execute('''
            INSERT INTO checked_products
              (name, checked_at, verdict, is_safe, barcode, composition,
               dangerous_components, additives)
            SELECT name, checked_at, verdict, is_safe, barcode, composition,
                   dangerous_components, additives
            FROM old_checked_products
            ORDER BY id DESC
          ''');
          await database.execute('DROP TABLE old_checked_products');
        }
      },
    );
    return _database!;
  }

  Future<List<CheckedProduct>> readProducts() async {
    final database = await open();
    final rows = await database.query('checked_products', orderBy: 'id DESC');
    return rows
        .map(ProductRecord.fromMap)
        .map((record) => record.product)
        .toList();
  }

  Future<void> saveProducts(List<CheckedProduct> values) async {
    final database = await open();
    await database.transaction((transaction) async {
      for (final product in values.reversed) {
        await transaction.insert(
          'checked_products',
          ProductRecord(product).toMap(),
        );
      }
    });
  }

  Future<void> insertProduct(CheckedProduct product) async {
    final database = await open();
    await database.insert('checked_products', ProductRecord(product).toMap());
  }

  Future<void> _createHistoryTable(Database database) async {
    await database.execute('''
      CREATE TABLE checked_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        checked_at TEXT NOT NULL,
        verdict TEXT NOT NULL,
        is_safe INTEGER NOT NULL,
        barcode TEXT NOT NULL,
        composition TEXT NOT NULL,
        dangerous_components TEXT NOT NULL,
        additives TEXT NOT NULL
      )
    ''');
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
