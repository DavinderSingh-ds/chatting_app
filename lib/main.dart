import 'package:chatting_app/Screens/ChatScreen.dart';
import 'package:chatting_app/Screens/LoginPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //now in main we will check if the user email is present in the key
  // then go to ChatScreen else LoginScreen
  //here in the app when we restart the app it will goto LoginPage
  //for this we will take email from key the email is remove from key when user click logout button else
  //it present all the time

  //initialize firebase
  // also add multiDex in the gradle
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();

  //getting email from email key
  var email = pref.getString("email");

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      //when email is null it go to login screen else chatscreen
      //now if we restart it will goto login page bcz. the email is currently not saved it will save main
      //we register to account or login to account
      //the email is currently empty so that why error occured
      //its occurs due to null safety
      //now if we restart or close our app then again open app ,it directly goto chatscreen
      //if we logout then restart it goto login screen
      home:
          email == null ? const LoginPage(title: 'Login') : const ChatScreen(),
    ),
  );
}
