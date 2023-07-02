import 'package:sqflite/sqflite.dart';
import 'package:database_app/database/db_controller.dart';

abstract class DbOperations<Model>{

  final Database database = DbController().database;

  Future<int> create (Model model);

  Future<List<Model>> read ();

  Future<Model?> show(int id);

  Future<bool> update (Model model);

  Future<bool> delete(int id);
}