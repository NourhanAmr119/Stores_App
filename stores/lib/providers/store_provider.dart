import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/store.dart';

class StoreProvider extends ChangeNotifier {
  late Database _db;
  Map<String, List<int>> _cachedFavorites = {};

  List<Store> _stores = [];
  List<Store> get stores => _stores;

  List<Store> _favorites = [];
  List<Store> get favorites => _favorites;

  StoreProvider() {
    initialize();
  }

  Future<void> initialize() async {
    _db = await _initializeDatabase();
    await _createTables();
    _addDummyStores();
    await fetchStores();
  }

  Future<Database> _initializeDatabase() async {
    final String path = await getDatabasesPath();
    final String dbPath = join(path, 'stores.db');
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await _createTables();
      },
    );
  }

  Future<void> _createTables() async {
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS stores(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)',
    );
    await _db.execute(
      'CREATE TABLE IF NOT EXISTS user_favorites(user_email TEXT, store_id INTEGER, PRIMARY KEY(user_email, store_id))',
    );
  }

  Future<void> fetchStores() async {
    final List<Map<String, dynamic>> storeMaps = await _db.query('stores');
    _stores = List.generate(storeMaps.length, (index) {
      return Store(
        id: storeMaps[index]['id'],
        name: storeMaps[index]['name'],
        latitude: storeMaps[index]['latitude'],
        longitude: storeMaps[index]['longitude'],
      );
    });
    notifyListeners();
  }

  Future<void> getFavorites(String userEmail) async {
    _favorites = [];
    final List<Map<String, dynamic>> maps = await _db.query(
      'user_favorites',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );

    final List<int> storeIds = maps.map<int>((item) => item['store_id'] as int).toList();

    _favorites = _stores.where((store) => storeIds.contains(store.id)).toList();

    _cachedFavorites[userEmail] = storeIds;

    print('Fetched favorites for $userEmail: $_favorites'); // Log the fetched favorites

    notifyListeners();
  }

  Future<bool> isStoreFavorited(String userEmail, int storeId) async {
    final List<Map<String, dynamic>> result = await _db.rawQuery(
      'SELECT COUNT(*) AS count FROM user_favorites WHERE user_email = ? AND store_id = ?',
      [userEmail, storeId],
    );
    return Sqflite.firstIntValue(result) == 1;
  }

  Future<void> addFavorite(String userEmail, int storeId) async {
    await _db.insert(
      'user_favorites',
      {'user_email': userEmail, 'store_id': storeId},
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
    await getFavorites(userEmail);
  }

  Future<void> removeFavorite(String userEmail, int storeId) async {
    await _db.delete(
      'user_favorites',
      where: 'user_email = ? AND store_id = ?',
      whereArgs: [userEmail, storeId],
    );
    await getFavorites(userEmail);
  }

  Future<bool> toggleFavorite(String userEmail, int storeId) async {
    bool isFavorited = await isStoreFavorited(userEmail, storeId);
    if (isFavorited) {
      await removeFavorite(userEmail, storeId);
    } else {
      await addFavorite(userEmail, storeId);
    }
    return !isFavorited;
  }

  void _addDummyStores() {
    _stores = [
      Store(id: 1, name: 'Store 1', latitude: 37.7749, longitude: -122.4194),
      Store(id: 2, name: 'Store 2', latitude: 34.0522, longitude: -118.2437),
      Store(id: 3, name: 'Store 3', latitude: 40.7128, longitude: -74.0060),
    ];
  }
}