// ignore_for_file: file_names
import 'package:chatting_app/Helper/FirebaseHelper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();
  final auth = FirebaseAuth.instance;

  //for current user
  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      //if user not empty it assign to login user
      loginUser = user;
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              service.signOut(context);
              //now here we remove that email from the key when user click logout button
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove("email");
              // it will remove user email when user click logout button
            },
            icon: const Icon(Icons.logout),
          ),
        ],
        title: Text(loginUser!.email.toString()),
      ),
    );
  }
}
