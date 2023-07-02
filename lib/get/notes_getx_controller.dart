import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:database_app/database/note_db_controller.dart';
import 'package:database_app/models/note.dart';
import 'package:database_app/models/process_response.dart';

class NotesGetxController extends GetxController{

  RxList<Note> notes = <Note>[].obs;
  RxBool loading = false.obs;

  final NoteDbController _dbController = NoteDbController();

  static NotesGetxController get to => Get.find<NotesGetxController>();


  @override
  void onInit() {
    read();
    super.onInit();
  }

  Future<ProcessResponse> create(Note note) async{
    int newRowId = await _dbController.create(note);
    if(newRowId != 0) {
      note.id = newRowId;
      notes.add(note);
      // update();
    }
      return getResponse(succuss: newRowId != 0);
    }

    void read() async{
     loading.value = true;
     notes.value = await _dbController.read();
     loading.value = false;
     // update(['home_screen']);
    }

    Future<ProcessResponse> updateNote(Note note) async{
      bool updated = await _dbController.update(note);
      if(updated) {
        int index = notes.indexWhere((element) => element.id == note.id);
      if(index != -1) {
        notes[index] = note;
        // update();
       }
      }
      return getResponse(succuss: updated);
    }

    Future<ProcessResponse> delete (int index) async{
      bool deleted = await _dbController.delete(notes[index].id);
      if(deleted){
        notes.removeAt(index);
        // update();
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
