import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_app/notes/domain/entities/note.dart';
import 'package:note_app/notes/domain/repository/note_repository.dart';

class FirebaseNoteRepository implements NoteRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CollectionReference noteCollection =
      FirebaseFirestore.instance.collection('notes');

  @override
  Future<void> createNote(Note note) async {
    try {
      await noteCollection.doc(note.id).set(note.toJson());
    } catch (e) {
      throw Exception("Error creating note $e");
    }
  }

  @override
  Future<void> deleteNote(String noteId) async {
    try {
      await noteCollection.doc(noteId).delete();
    } catch (e) {
      throw Exception("Error deleting note $e");
    }
  }

  @override
  Future<List<Note>> searchNotesForTitle(String title) async {
    try {
      //sort notes descending
      final noteSnapshot =
          await noteCollection.where('title', isEqualTo: title).get();

      // convert each document from json to list
      final List<Note> allNotes = noteSnapshot.docs
          .map((docu) => Note.fromJson(docu.data() as Map<String, dynamic>))
          .toList();

      return allNotes;
    } catch (e) {
      throw Exception("Error fetching notes $e");
    }
  }

  @override
  Future<List<Note>> fetchNoteByUserId(String userId) async {
    try {
      final noteSnapshot =
          await noteCollection.where('userId', isEqualTo: userId).get();
      final List<Note> userNote = noteSnapshot.docs
          .map((doc) => Note.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return userNote;
    } catch (e) {
      throw Exception("Error fetching notes by user $e");
    }
  }

  @override
  Future<void> updateNote(Note updatedNote) async {
    try {
      await noteCollection
          .doc(updatedNote.id)
          .update({'title': updatedNote.title, 'text': updatedNote.text});
    } catch (e) {
      throw Exception("Error updating note $e");
    }
  }

  @override
  Future<Note> fetchNoteById(String noteId) async {
    try {
      final noteSnapshot = await noteCollection.doc(noteId).get();
      final userNote =
          Note.fromJson(noteSnapshot.data() as Map<String, dynamic>);
      return userNote;
    } catch (e) {
      throw Exception("Error fetching note by id $e");
    }
  }
}
