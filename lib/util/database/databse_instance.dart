import 'package:sqflite/sqflite.dart';

abstract class DatabaseInstance {
  Future<Database> getDatabase();
}