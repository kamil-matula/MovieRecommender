import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // TODO: Customize it or remove it
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TODO: Add input fields and buttons
          const Text('Login Page'),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                FirebaseAuth.instance.signInAnonymously();
              },
              child: const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}
