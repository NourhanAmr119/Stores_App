import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/store.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'stores.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Stores(id INTEGER PRIMARY KEY, name TEXT, latitude REAL, longitude REAL)',
    );

    // Insert dummy data
    await db.transaction((txn) async {
      await txn.rawInsert(
          'INSERT INTO Stores(name, latitude, longitude) VALUES("Store 1", 37.7749, -122.4194)');
      await txn.rawInsert(
          'INSERT INTO Stores(name, latitude, longitude) VALUES("Store 2", 34.0522, -118.2437)');
      await txn.rawInsert(
          'INSERT INTO Stores(name, latitude, longitude) VALUES("Store 3", 40.7128, -74.0060)');
    });
  }

  Future<List<Store>> getStores() async {
    var dbClient = await db;
    List<Map<String, dynamic>> list =
        await dbClient.rawQuery('SELECT * FROM Stores');
    List<Store> stores = [];
    for (int i = 0; i < list.length; i++) {
      stores.add(Store.fromMap(list[i]));
    }
    return stores;
  }
}
