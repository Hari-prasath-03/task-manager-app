import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/features/auth/domain/user_model.dart';

class AuthLocalRepository {
  final String _tableName = 'users';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    await initDatabase();
    return _database!;
  }

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'auth.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createUsersTable(db);
      },
    );
  }

  Future<void> _createUsersTable(Database db) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        token TEXT NOT NULL,
        email TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');
  }

  Future<void> insertUser(UserModel user) async {
    final db = await database;
    final data = user.toMap();
    await db.insert(
      _tableName,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final maps = await db.query(_tableName);
    if (maps.isNotEmpty) return UserModel.fromMap(maps.first);
    return null;
  }

  Future<void> deleteUser() async {
    final db = await database;
    await db.delete(_tableName);
  }
}
