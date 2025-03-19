import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/data/firebase_auth_repository.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/auth/presentation/cubits/auth_states.dart';
import 'package:note_app/auth/presentation/pages/auth_page.dart';
import 'package:note_app/notes/data/firebase_note_repository.dart';
import 'package:note_app/notes/presentation/cubits/note_cubits.dart';
import 'package:note_app/notes/presentation/pages/home_page.dart';
import 'package:note_app/theme/theme.dart';

class MyApp extends StatelessWidget {
  final authRepo = FirebaseAuthRepository();
  final noteRepo = FirebaseNoteRepository();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkUser(),
        ),
        BlocProvider<NoteCubit>(
          create: (context) => NoteCubit(noteRepository: noteRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: defaultTheme,
        home: BlocConsumer<AuthCubit, AuthState>(
          builder: (context, authState) {
            print(authState);
            if (authState is UnAuthenticated) {
              return const AuthPage();
            }
            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
