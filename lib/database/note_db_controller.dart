import 'package:database_app/database/db_operations.dart';
import 'package:database_app/models/note.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';

class NoteDbController extends DbOperations<Note> {
  @override
  Future<int> create(Note model) async{
    // int newRowId = await database.rawInsert('INSERT INTO notes(title, info, user_id) VALUES (?, ?, ?)',
    //     [model.title, model.info, model.userId]);

    return await database.insert(Note.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async{
   // int countOfDeletedRows = await database.rawDelete('DELETE FROM notes WHERE id = ?',[id]);
    int userId = SharedPrefController().getValueFor(key: PrefKeys.id.name)!;
    int countOfDeletedRows =
    await database.delete(Note.tableName,where: 'id = ? AND user_id = ?',whereArgs: [id,userId]);
    return countOfDeletedRows == 1;
  }

  @override
  Future<List<Note>> read() async{
    int userId = SharedPrefController().getValueFor(key: PrefKeys.id.name)!;
    // List<Map<String,dynamic>> rowsMap = await database.rawQuery('SELECT * FROM notes WHERE user_id = ?',
    //     [userId],
    // );
    List<Map<String,dynamic>> rowsMap = await database.query(
        Note.tableName,
        where: 'user_id = ?',
        whereArgs: [userId]
    );
    return rowsMap.map((rowMap) => Note.fromMap(rowMap)).toList();
  }

  @override
  Future<Note?> show(int id) async{
  // List<Map<String, dynamic>> rowsMap = await database.rawQuery('SELECT FROM notes WHERE id = ?', [id]);
    List<Map<String,dynamic>> rowsMap = await database.query(Note.tableName,where: 'id = ?',whereArgs: [id]);
    return rowsMap.isNotEmpty? Note.fromMap(rowsMap.first) : null;
  }

  @override
  Future<bool> update(Note model) async{
    int userId = SharedPrefController().getValueFor(key: PrefKeys.id.name)!;
    // int countOfUpdatedRows = await database.rawUpdate(
    //     'UPDATE notes SET title = ?, info = ?, WHERE id = ? AND user_id = ?',
    //   [note.title, note.info, note.id, userId]
    // );
    int countOfUpdateRows = await database.update(
      Note.tableName,
      model.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [model.id, userId]
    );
    return countOfUpdateRows == 1;
  }

}