// ignore_for_file: file_names

import 'package:chatting_app/Screens/ChatScreen.dart';
import 'package:chatting_app/Screens/LoginPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Service {
  //all firebase auth
  final auth = FirebaseAuth.instance;

  //for create User we define function
  void createUser(context, name, email, password) async {
    try {
      //when the user create it will go to chatscreen directly not to login page
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => const ChatScreen()),
                ),
              ),
              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(auth.currentUser!.uid)
                  .set({"name": name, "email": email, "status": "online"})
            },
          );
    } catch (e) {
      //if it has some error then it will show dialogue
      errorBox(context, e);
    }
  }

  //for Login User we define loginUser Function
  void loginUser(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (value) => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              ),
            },
          );
    } catch (e) {
      //if it has some error then it will show dialogue
      errorBox(context, e);
    }
  }

  //for Signout
  void signOut(context) async {
    try {
      //this functon helps to signout user
      await auth.signOut().then((value) => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPage(title: 'Title'),
                ),
                (route) => false)
          });
    } catch (e) {
      //if it has some error then it will show dialogue
      errorBox(context, e);
    }
  }

  //for displaying errors we define errorBox function
  void errorBox(context, e) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Hey dear!'),
            content: Text(e.toString()),
          );
        });
  }
}
