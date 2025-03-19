import 'package:note_app/notes/domain/entities/note.dart';

abstract class NoteState {}

class NotesInitial extends NoteState {}

class NotesLoading extends NoteState {}

class NotesUploading extends NoteState {}

class NotesError extends NoteState {
  final String message;
  NotesError(this.message);
}

class NoteLoaded extends NoteState {
  final List<Note> notes;
  NoteLoaded(this.notes);
}
