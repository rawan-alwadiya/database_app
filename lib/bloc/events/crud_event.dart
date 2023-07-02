import 'package:database_app/models/note.dart';

class CrudEvent {}

class CreateEvent extends CrudEvent {
  final Note note;

  CreateEvent(this.note);
 }

 class ReadEvent extends CrudEvent {}

 class UpdateEvent extends CrudEvent {
  final Note note;

  UpdateEvent(this.note);
 }

 class DeleteEvent extends CrudEvent{
  final int index;

  DeleteEvent(this.index);
 }