import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController{

  late Database _database;
  static DbController? _instance;
  DbController._();

  factory DbController (){
    return _instance ??= DbController._();
  }

  Database get database => _database;

  Future<void> initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path,'app_db.sql');
    _database = await openDatabase(
        path,
        version: 1,
      onOpen: (Database database){},
      onCreate: (Database database,int version) async{
          //TODO: Create Tables using SQL (users, notes)
        await database.execute('CREATE TABLE users ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'email TEXT NOT NULL,'
            'password TEXT NOT NULL'
            ')');
        await database.execute('CREATE TABLE notes ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'title TEXT NOT NULL,'
            'info TEXT,'
            'user_id INTEGER,'
            'FOREIGN KEY (user_id) references users(id)'
            ')');
      },
      onUpgrade: (Database database, int oldVersion,int newVersion){},
      onDowngrade: (Database database, int oldVersion,int newVersion){}
    );
  }

}

/**
 * SQL Queries Summary:
 * => Operations: CRUD
 *   => C: Create
 *   => R: Read
 *   => U: Update
 *   => D: Delete
 * ---------------------
 * => Queries Types:
 *   1) Insert
 *   2) Select
 *   3) Update
 *   4) Delete
 *  ---------------------
 *  => Examples:
 *   1) Insert:
 *     => INSERT INTO tableName (c1, c2, c3) VALUES (v1, v2,v3);
 *     => INSERT INTO tableName VALUES (v1, v2,v3);
 *
 *   2) Select:
 *     => SELECT * FROM tableName;
 *     => SELECT c1, c2 FROM tableName;
 *     => SELECT c1, c2 FROM tableName WHERE c1 = value;
 *     => SELECT c1, c2 FROM tableName WHERE c1 = value AND c2 = value;
 *     => SELECT c1, c2 FROM tableName WHERE c1 = value OR c2 = value;
 *
 *   3) Update:
 *     => UPDATE tableName SET c1 = v1;
 *     => UPDATE tableName SET c1 = v1 WHERE c2 = v2;
 *
 *   4) Delete:
 *     => DELETE FROM tableName;
 *     => DELETE FROM tableName WHERE c1 = v1;
 *  ---------------------
 *  Alter:
 *    => Alter tableName ADD columnName TEXT NOT NULL AFTER id;
 *  DROP:
 *    => DROP TABLE tableName;
 *  SHOW TABLE COLUMNS:
 *    => show columns from tableName;
 *  SHOW TABLES:
 *    => shaw tables;
 *
*/