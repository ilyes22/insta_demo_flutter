import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  File? img;
  bool isSignIn = false;
  final emailConrtoller = TextEditingController();
  final passwordConrtoller = TextEditingController();
  final usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: MediaQuery.of(context).systemGestureInsets.isNonNegative,
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 129, 20, 148),
                Colors.amber
              ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildLogo(),
                  buildCardInformation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogo() {
    return CircleAvatar(
      radius: isSignIn ? 30 : 70,
      child: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Instagram_icon.png/800px-Instagram_icon.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildCardInformation() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: SizedBox(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildInputInformationUser(),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 1, 66),
                      foregroundColor: Colors.amber),
                  onPressed: isSignIn ? singin : logInin,
                  child: Text(isSignIn ? 'Sign Up' : 'log In'),
                ),
                const SizedBox(height: 10),
                buildTextForSigneInCheack(
                  isSignIn ? 'i Already have acount' : ' Create a new Account',
                  isSignIn ? 'Log In' : 'Sign In',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextForSigneInCheack(String text, String signState) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        text,
      ),
      TextButton(
        onPressed: () {
          setState(() {
            isSignIn = !isSignIn;
          });
        },
        child: Text(
          signState,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 56, 1, 66)),
        ),
      ),
    ]);
  }

  Widget buildInputInformationUser() {
    //create text fielf for : gmail,password,userName....
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSignIn)
            const SizedBox(
              height: 20,
            ),
          if (isSignIn)
            TextField(
              controller: usernameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8),
                label: Text(
                  'User Name',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              autocorrect: false,
            ),
          const SizedBox(
            height: 10,
          ),

          //Email
          TextField(
            controller: emailConrtoller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8),
              label: Text(
                'Email',
                style: TextStyle(color: Colors.black),
              ),
            ),
            autocorrect: false,
          ),
          const SizedBox(
            height: 10,
          ),

          //Password
          TextField(
            controller: passwordConrtoller,
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(
              label: Text(
                'Password',
                style: TextStyle(color: Colors.black),
              ),
              contentPadding: EdgeInsets.all(8),
            ),
            autocorrect: false,
            obscureText: true,
          ),
        ],
      ),
    );
  }

  void logInin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailConrtoller.text,
        password: passwordConrtoller.text,
      );
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }

  void singin() async {
    try {
      if (emailConrtoller.text.isEmpty ||
          passwordConrtoller.text.isEmpty ||
          img == null) {
        return;
      }

      // Sign Up
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailConrtoller.text,
        password: passwordConrtoller.text,
      );
      final userId = userCredential.user!.uid;

      // Upload picture if it exists
      if (img != null) {
        final storageRef =
            FirebaseStorage.instance.ref('User Images/$userId.jpg');
        await storageRef.putFile(img!);

        final imageUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance.collection('Data').doc(userId).set({
          'username': usernameController.text,
          'email': emailConrtoller.text,
          'image': imageUrl,
          'time': Timestamp.now(),
          'id': userId,
        });
      }
      print('Account created successfully=============================');
    } on FirebaseAuthException catch (e) {
      // Log the error message
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? '')));
      }
    }
  }
}
