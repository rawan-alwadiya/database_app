import 'package:sqflite/sqflite.dart';
import 'package:database_app/database/db_controller.dart';
import 'package:database_app/models/users.dart';
import 'package:database_app/prefs/shared_pref_controller.dart';

import '../models/process_response.dart';

class UserDbController{

  final Database _database = DbController().database;

  Future<ProcessResponse> login({required String email, required String password}) async{
    // List<Map<String,dynamic>> rowsMap = await _database.rawQuery(
    //     'SELECT * FROM users WHERE email = ? AND password = ?',
    //     [email, password]);
    List<Map<String,dynamic>> rowsMap = await _database.query(
      User.tableName,
      where: 'email = ? AND password = ?',
      whereArgs: [email,password],
    );
    if(rowsMap.isNotEmpty){
      User user = User.fromMap(rowsMap.first);
      SharedPrefController().save(user: user);
      return ProcessResponse(massage: 'Logged in successfully',success: true);
    }
    return ProcessResponse(massage: 'Login failed',success: false);
  }

  Future<ProcessResponse> register({required User user}) async{
    if(await isEmailNotExist(email: user.email)){
    //  int newRowId = await _database.rawInsert('INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
    //     [user.name, user.email,user.password]
    //   );
      int newRowId = await _database.insert(User.tableName, user.toMap());
      return ProcessResponse(
        massage: newRowId !=0? 'Registered successfully':'Registered failed',
        success: newRowId != 0);
    }
    return ProcessResponse(massage: 'Email exists, use another');
  }

  Future<bool> isEmailNotExist({required String email}) async{
    List<Map<String,dynamic>> rowsMap = await _database.rawQuery(
        'SELECT * FROM users WHERE email = ?',[email]
    );
    return rowsMap.isEmpty;
  }
}