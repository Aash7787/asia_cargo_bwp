import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class LocalDatabaseBilty {
  static const dbVersion = 1;

  static LocalDatabaseBilty? _instance;

  LocalDatabaseBilty._namedConstructor();

  factory LocalDatabaseBilty() =>
      _instance ??= LocalDatabaseBilty._namedConstructor();

  static Database? _db;

  Future<Database> get database async => _db ??= await openDatabase(
        path.join(
          await getDatabasesPath(),'BiltyItems'
        ),
      );
}
