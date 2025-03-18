import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/auth/presentation/widgets/auth_button.dart';
import 'package:note_app/auth/presentation/widgets/input_field.dart';

class LoginPage extends StatefulWidget {
  final void Function()? togglePages;
  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() {
    final String email = emailController.text;
    final String password = passwordController.text;

    //Auth cubit
    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.signin(email, password);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ingrese el usuario y la contraseña")));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock_open_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 50),
                Text(
                  "Bienvenido!!",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 25),
                InputField(
                  controller: emailController,
                  hintTex: "email",
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                InputField(
                  controller: passwordController,
                  hintTex: "password",
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                AuthButton(onTap: login, text: 'Login'),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No eres miembro ? ",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    GestureDetector(
                      onTap: widget.togglePages,
                      child: Text(
                        "Crea una cuenta",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
