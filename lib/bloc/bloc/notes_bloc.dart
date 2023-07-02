import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:database_app/bloc/events/crud_event.dart';
import 'package:database_app/bloc/states/crud_state.dart';
import 'package:database_app/database/note_db_controller.dart';
import 'package:database_app/models/note.dart';

class NotesBloc extends Bloc<CrudEvent,CrudState>{
  NotesBloc(super.initialState){
    // on<E extends Event>((E,emit)=>null);
    // on<CreateEvent>((Create Event event,Emitter<CrudState> emitter)=>null);
    on<CreateEvent>(_createEvent);
    on<ReadEvent>(_readEvent);
    on<UpdateEvent>(_updateEvent);
    on<DeleteEvent>(_deleteEvent);
  }

  List<Note> _notes = <Note>[];
  final NoteDbController _dbController =NoteDbController();

  void _createEvent(CreateEvent event, Emitter<CrudState> emit) async{
    int newRowId = await _dbController.create(event.note);
    if(newRowId != 0){
      event.note.id = newRowId;
      _notes.add(event.note);
      emit(ReadState(_notes));
    }
    emit(
        ProcessState(
          processType: ProcessType.create,
          status: newRowId != 0,
          message: newRowId != 0
              ? 'Operation Completed Successfully'
              : 'Operation Failed'));
  }
  void _readEvent(ReadEvent event, Emitter<CrudState> emit) async{
    emit(LoadingState());
    _notes = await _dbController.read();
    emit(ReadState(_notes));
  }

  void _updateEvent(UpdateEvent event, Emitter<CrudState> emit) async{
    bool updated = await _dbController.update(event.note);
    if(updated){
      int index = _notes.indexWhere((element) => element.id == event.note.id);
      if(index != -1){
        _notes[index] = event.note;
        emit(ReadState(_notes));
      }
      emit(ProcessState(
          processType: ProcessType.update,
          status: updated,
          message: updated
              ? 'Operation Completed Successfully'
              :'Operation Failed'));
    }
  }

  void _deleteEvent(DeleteEvent event, Emitter<CrudState> emit) async{
    bool deleted = await _dbController.delete(_notes[event.index].id);
    if(deleted){
      _notes.removeAt(event.index);
      emit(ReadState(_notes));
    }
    emit(ProcessState(
        processType: ProcessType.update,
        status: deleted,
        message: deleted
            ? 'Operation Completed Successfully'
            :'Operation Failed'));
  }
}