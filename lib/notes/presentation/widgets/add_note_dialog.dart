import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/domain/entities/app_user.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/notes/domain/entities/note.dart';
import 'package:note_app/notes/presentation/cubits/note_cubits.dart';

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog({super.key});

  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  AppUser? currentUser;
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void uploadNote() {
    final String title = titleController.text;
    final String description = descriptionController.text;

    if (title.isNotEmpty && description.isNotEmpty) {
      if (currentUser != null) {
        //Create a new note
        final newNote = Note(
          id: "${currentUser!.uid}${DateTime.now().millisecondsSinceEpoch.toString()}",
          userId: currentUser!.uid,
          title: title,
          text: description,
          timestamp: DateTime.now(),
        );
        final noteCubit = context.read<NoteCubit>();
        noteCubit.createNote(newNote);
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("El titulo y la nota es requerida")));
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      title: const Text(
        "Agrega tu nota",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      content: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                    labelText: "Titulo", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    labelText: "Nota", border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.inversePrimary),
            onPressed: () {
              uploadNote();
            },
            child: const Text("Agregar")),
      ],
    );
  }
}
