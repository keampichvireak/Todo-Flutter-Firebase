// ignore_for_file: prefer_const_constructors, empty_statements, use_build_context_synchronously, avoid_print, prefer_const_constructors_in_immutables, duplicate_ignore, non_constant_identifier_names

import 'package:authflutter/components/my_button.dart';
import 'package:authflutter/components/my_textfield.dart';
import 'package:authflutter/components/square_tile.dart';
import 'package:authflutter/models/usermodel/user.dart';
import 'package:authflutter/pages/home_page.dart';
import 'package:authflutter/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //FIXME: DATA SAVE INTO FIREBASE
    Future<void> saveUserDataToFirestore(User user) async {
      UserModal userModel = UserModal(
        uid: user.uid,
        email: user.email!,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());
    }

    void ErrorMessage(String message) {
      showDialog(
          context: context,
          builder: (builder) {
            return AlertDialog(
              title: Center(
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            );
          });
    }

    void signUserUp() async {
      // Show loading circle
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        User? user = userCredential.user;

        if (user != null) {
          // Save user data to Firestore
          await saveUserDataToFirestore(user);
        }

        // Pop the loading circle
        Navigator.pop(context);
        emailController.clear();
        passwordController.clear();
        // ignore: avoid_print
        print("Successfully created a new user");
        // Navigator.pushNamed(context, '/login');
      } on FirebaseAuthException catch (e) {
        Navigator.pop(context); // Ensure loading circle is dismissed
        ErrorMessage(e.code);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Register Page"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),

                // logo
                const Icon(
                  Icons.lock,
                  size: 100,
                ),

                const SizedBox(height: 50),

                // welcome back, you've been missed!
                Text(
                  'Join us today! Fill out the form to create an account.',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 25),
                MyTextField(
                  controller: emailController,
                  hintText: 'email',
                  obscureText: false,
                ),
                const SizedBox(
                  height: 10,
                ),

                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),

                const SizedBox(height: 10),

                // forgot password?
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'Forgot Password?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // sign in button
                MyButton(
                  onTap: signUserUp,
                  SubmitText: "Sign up",
                ),

                const SizedBox(height: 50),

                // or continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 50),

                // google + apple sign in buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // google button
                    SquareTile(
                        imagePath: 'lib/images/google.png',
                        onTap: () async {
                          await AuthService().signInWithGoogle();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        }),

                    SizedBox(width: 25),
                  ],
                ),

                const SizedBox(height: 50),

                // not a member? register now
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already a member?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        'Login now',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
