// ignore_for_file: file_names

import 'package:chatting_app/Helper/FirebaseHelper.dart';
import 'package:chatting_app/Screens/RegisterPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey _formKey = GlobalKey();

  //here we take intance of service class
  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login Page',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Email ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Your Password ',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: MaterialButton(
                    minWidth: 400,
                    height: 50,
                    color: Colors.amber,
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      //if email and passwords is not empty it will take action on it
                      if (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty) {
                        service.loginUser(context, _emailController.text,
                            _passwordController.text);
                        // it will save userEmail in email key
                        // from this key we will check,if email key is present in the key go to Chatscreen else LoginScreen
                        pref.setString("email", _emailController.text);
                      } else {
                        //if textfields are empty it show warning message
                        service.errorBox(context,
                            "Fields must not empty please provide valid email and password !");
                      }
                    },
                    child: const Text("Login"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) =>
                              const RegisterPage(title: "Register Page")),
                        ),
                      );
                    },
                    child: const Text("Don't have an account ?"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
