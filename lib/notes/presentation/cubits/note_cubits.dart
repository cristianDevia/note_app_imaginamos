import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/notes/domain/entities/note.dart';
import 'package:note_app/notes/domain/repository/note_repository.dart';
import 'package:note_app/notes/presentation/cubits/note_states.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository noteRepository;

  NoteCubit({required this.noteRepository}) : super(NotesInitial());

  Future<void> createNote(Note note) async {
    try {
      emit(NotesLoading());
      final createNote = await noteRepository.createNote(note);
      return createNote;
    } catch (e) {
      emit(NotesError("Failed to create note ${e.toString()}"));
    }
  }

  Future<void> fetchNoteByUserId(String userId) async {
    try {
      emit(NotesLoading());
      final notes = await noteRepository.fetchNoteByUserId(userId);
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NotesError("Failed to fetch note ${e.toString()}"));
    }
  }

  Future<void> searchNotesForTitle(String title) async {
    try {
      emit(NotesLoading());
      final notes = await noteRepository.searchNotesForTitle(title);
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NotesError("Failed to search notes ${e.toString()}"));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await noteRepository.deleteNote(noteId);
    } catch (e) {
      emit(NotesError("Failed to delete note ${e.toString()}"));
    }
  }

  Future<void> updateNote({
    required String id,
    String? newTitle,
    String? newText,
  }) async {
    try {
      emit(NotesLoading());
      //current note
      final currentNote = await noteRepository.fetchNoteById(id);
      final updatedNote = currentNote.updateNote(
          newTitle: newTitle ?? currentNote.title,
          newTex: newText ?? currentNote.text);
      await noteRepository.updateNote(updatedNote);
      await fetchNoteByUserId(updatedNote.userId);
    } catch (e) {
      emit(NotesError("Failed to updated note ${e.toString()}"));
    }
  }
}
