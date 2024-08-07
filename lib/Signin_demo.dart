import 'package:flutter/material.dart';
import 'package:google_map/service_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SigninDemo extends StatefulWidget {
  const SigninDemo({super.key});

  @override
  State<SigninDemo> createState() => _SigninDemoState();
}

class _SigninDemoState extends State<SigninDemo> {
  String? _email;

  void _signIn() async {
    AuthService authService = AuthService();
    User? user = await authService.signInWithGoogle();
    if (user != null) {
      setState(() {
        _email = user.email;
      });
      print('Signed in successfully with email: ${user.email}');
    } else {
      print('*********************************Sign-in process was unsuccessful.***********************************${user?.email}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign in'),
            ),
            if (_email != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Signed in as: $_email'),
              ),
          ],
        ),
      ),
    );
  }
}
