import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:note_app/auth/presentation/cubits/auth_cubits.dart';
import 'package:note_app/auth/presentation/widgets/auth_button.dart';
import 'package:note_app/auth/presentation/widgets/input_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controller
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void register() {
    final String name = nameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = passwordController.text;

    final authCubit = context.read<AuthCubit>();

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty) {
      if (password == confirmPassword) {
        authCubit.signUp(name, email, password);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Las contraseñas no coinciden")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Por favor complete todos los campos")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: SingleChildScrollView(
              child: SizedBox(
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
                      "Crea una cuenta!!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 25),
                    InputField(
                      controller: nameController,
                      hintTex: "name",
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
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
                    InputField(
                      controller: confirmPasswordController,
                      hintTex: "confirm password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    AuthButton(
                        onTap: () {
                          register();
                        },
                        text: 'Register'),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Eres miembro ? ",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                        ),
                        GestureDetector(
                          onTap: widget.togglePages,
                          child: Text(
                            "Inicia sesion",
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
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
        ),
      ),
    );
  }
}
