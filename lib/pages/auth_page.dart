import 'package:authflutter/pages/home_page.dart';
import 'package:authflutter/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              //use is logged in
              if (snapshot.hasData) {
                return HomePage();
              } else {
                return LoginPage();
              }

              //user is not Logged in
            }));
  }
}
