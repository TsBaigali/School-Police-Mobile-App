import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/ad.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'ads.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE ads(id TEXT PRIMARY KEY, userName TEXT, profilePic TEXT, address TEXT, price TEXT, date TEXT, shift TEXT, additionalInfo TEXT)',
        );
      },
    );
  }

  Future<void> insertAd(Ad ad) async {
    final db = await database;
    await db.insert(
      'ads',
      ad.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Ad>> getAds() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ads');
    return List.generate(maps.length, (i) {
      return Ad.fromMap(maps[i]); // Assuming you have a fromMap() method in your Ad model
    });
  }

  Future<void> deleteAd(String id) async {
    final db = await database;
    await db.delete(
      'ads',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
