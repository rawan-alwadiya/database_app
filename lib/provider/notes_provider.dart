import 'package:flutter/material.dart';
import 'package:database_app/database/note_db_controller.dart';
import 'package:database_app/models/note.dart';
import 'package:database_app/models/process_response.dart';

class NotesProvider extends ChangeNotifier{

  List<Note> notes = <Note>[];
  final NoteDbController _dbController = NoteDbController();

  Future<ProcessResponse> create(Note note) async{
    int newRowId = await _dbController.create(note);
    if(newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      notifyListeners();
    }
      return getResponse(succuss: newRowId != 0);
    }

    void read() async{
     notes = await _dbController.read();
     notifyListeners();
    }

    Future<ProcessResponse> update(Note note) async{
      bool updated = await _dbController.update(note);
      if(updated) {
        int index = notes.indexWhere((element) => element.id == note.id);
      if(index != -1) {
        notes[index] = note;
        notifyListeners();
       }
      }
      return getResponse(succuss: updated);
    }

    Future<ProcessResponse> delete (int index) async{
      bool deleted = await _dbController.delete(notes[index].id);
      if(deleted){
        notes.removeAt(index);
        notifyListeners();
      }
      return getResponse(succuss: deleted);
    }

    ProcessResponse getResponse({required bool succuss}){
      return ProcessResponse(
        massage: succuss? 'Operation completed successfully' : 'Operation failed',
        success: succuss,
      );
    }
  }
