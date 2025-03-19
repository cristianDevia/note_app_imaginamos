import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/domain/entities/app_user.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/notes/presentation/cubits/note_cubits.dart';

class SearchInputBar extends StatefulWidget {
  const SearchInputBar({super.key});

  @override
  State<SearchInputBar> createState() => _SearchInputBarState();
}

class _SearchInputBarState extends State<SearchInputBar> {
  AppUser? currentUser;
  late final noteCubit = context.read<NoteCubit>();
  final searchController = TextEditingController();

  void searchTitle() {
    final searchText = searchController.text;
    if (searchText.isNotEmpty) {
      noteCubit.searchNotesForTitle(searchText);
    } else {
      noteCubit.fetchNoteByUserId(currentUser!.uid);
    }
  }

  void getCurrentUser() async {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10),
      child: TextField(
        controller: searchController,
        onChanged: (query) {
          searchTitle();
        },
        decoration: InputDecoration(
          labelText: 'Buscar por titulo',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
