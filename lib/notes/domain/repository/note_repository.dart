import 'package:note_app/notes/domain/entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> searchNotesForTitle(String title);
  Future<void> createNote(Note note);
  Future<void> deleteNote(String noteId);
  Future<List<Note>> fetchNoteByUserId(String userId);
  Future<void> updateNote(Note updatedNote);
  Future<Note> fetchNoteById(String noteId);
}
