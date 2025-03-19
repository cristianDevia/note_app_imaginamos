import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:note_app/auth/domain/entities/app_user.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/notes/domain/entities/note.dart';
import 'package:note_app/notes/presentation/cubits/note_cubits.dart';
import 'package:note_app/notes/presentation/cubits/note_states.dart';
import 'package:note_app/notes/presentation/widgets/add_note_dialog.dart';
import 'package:note_app/notes/presentation/widgets/search_input_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppUser? currentUser;
  late final noteCubit = context.read<NoteCubit>();

  //on startup
  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchNotes();
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  void fetchNotes() {
    noteCubit.fetchNoteByUserId(currentUser!.uid);
  }

  void deleteNote(String noteId) {
    noteCubit.deleteNote(noteId);
    fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Imaginamos NoteApp"),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().logOut();
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: Column(
        children: [
          const SearchInputBar(),
          BlocBuilder<NoteCubit, NoteState>(builder: (context, state) {
            print(state);
            //loading notes
            if (state is NotesLoading && state is NotesUploading) {
              return const Center(
                child: CircularProgressIndicator(),
              );

              // notes loaded
            } else if (state is NoteLoaded) {
              final notes = state.notes;
              if (notes.isEmpty) {
                return const Center(
                  child: Text("No hay notas disponibles"),
                );
              }
              return Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];

                    return Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Slidable(
                        key: ValueKey(note.id),
                        startActionPane:
                            ActionPane(motion: const DrawerMotion(), children: [
                          SlidableAction(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            onPressed: (context) {
                              _deleteNoteDialog(note.id);
                            },
                          ),
                          SlidableAction(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            onPressed: (context) {
                              _updateNote(note);
                            },
                          )
                        ]),
                        child: ListTile(
                          title: Text(
                            note.title,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(
                            note.text,
                          ),
                          trailing: Text(
                              "${note.timestamp.day} / ${note.timestamp.month} / ${note.timestamp.year}"),
                        ),
                      ),
                    );
                  },
                ),
              );
            }

            // notes error
            else if (state is NotesError) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          }),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onPressed: () {
          showDialog(
              context: context, builder: (context) => const AddNoteDialog());
        },
      ),
    );
  }

  void _deleteNoteDialog(String noteId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Eliminar Nota ?"),
        actions: [
          //cancel
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancelar"),
          ),

          //delete
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                deleteNote(noteId);
                Navigator.of(context).pop();
              },
              child: const Text("Eliminar"))
        ],
      ),
    );
  }

  void _updateNote(Note note) {
    showDialog(
        context: context,
        builder: (context) => AddNoteDialog(
              updateNote: note,
            ));
  }
}
