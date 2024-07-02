import 'package:path/path.dart';
import 'package:smart_shopping_list/util/database/databse_instance.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseInstanceImpl extends DatabaseInstance {
  // DatabaseInstance._privateConstructor();
  // static final DatabaseInstance _instance =
  //     DatabaseInstance._privateConstructor();
  static Database? _database;

  // factory DatabaseInstance() => _instance;

  @override
  Future<Database> getDatabase() async {
    if (DatabaseInstanceImpl._database != null)
      return DatabaseInstanceImpl._database!;
    DatabaseInstanceImpl._database = await initDB();
    return DatabaseInstanceImpl._database!;
  }

  // Future<Database> get database async {
  //   if (_database != null) return _database!;
  //   _database = await initDB();
  //   return _database!;
  // }

  Future<Database> initDB() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'article_database.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE articles(name TEXT PRIMARY KEY, currentAmount REAL, dailyUsage REAL, unit TEXT, rebuyAmount REAL, lastUsage TEXT)',
        );
      },
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          return db.execute(
              'CREATE TABLE shopping_list(name TEXT PRIMARY KEY, amount REAL, unit TEXT, checked INTEGER DEFAULT 0)');
        }
      },
      version: 2,
    );
    return database;
  }
}
