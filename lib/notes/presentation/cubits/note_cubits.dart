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
      emit(NotesError("Failed to create note $e"));
    }
  }

  Future<void> fetchNoteById(String userId) async {
    try {
      emit(NotesLoading());
      final notes = await noteRepository.fetchNoteByUserId(userId);
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NotesError("Failed to fetch note $e"));
    }
  }

  Future<void> deleteNote(String noteId) async {
    try {
      await noteRepository.deleteNote(noteId);
    } catch (e) {
      emit(NotesError("Failed to delete note $e"));
    }
  }
}
