import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/cubit/auth_cubit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> _login(BuildContext context) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      context.read<AuthCubit>().signIn(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _register(BuildContext context) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      context.read<AuthCubit>().signUp(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed: $e")),
      );
    } finally {
      setState(() => isLoading = false);
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
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          _verifyTokenAndNavigate(context, state.user!.getIdToken() as Future<String> Function(), '/quiz-list');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: const Text('Login or Register')),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: const Text("Login"),
                ),
                ElevatedButton(
                  onPressed: () => _register(context),
                  child: const Text("Register"),
                ),
                const SizedBox(height: 16),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _verifyTokenAndNavigate(BuildContext context, Future<String> Function() getIdToken, String routeName) async {
    try {
      String idToken = await getIdToken();

      final response = await http.post(
        Uri.parse("http://localhost:8080/auth/verify"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"token": idToken}),
      );

      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verification failed: $e")),
      );
    }
  }
}