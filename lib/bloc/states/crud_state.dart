import 'package:database_app/models/note.dart';

enum ProcessType {create, update, delete}

class CrudState {}

class LoadingState extends CrudState {}

class ProcessState extends CrudState {
  final bool status;
  final String message;
  final ProcessType processType;

  ProcessState({
    required this.processType,
    required this.status,
    required this.message
  });
}
class ReadState extends CrudState{
  final List<Note> notes;

  ReadState(this.notes);
}