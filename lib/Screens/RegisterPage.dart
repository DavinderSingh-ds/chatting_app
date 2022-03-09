// ignore_for_file: file_names

import 'package:chatting_app/Helper/FirebaseHelper.dart';
import 'package:chatting_app/Screens/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  'SignUp Page',
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
                        service.createUser(context, _emailController.text,
                            _passwordController.text);
                        pref.setString("email", _emailController.text);
                      } else {
                        //if textfields are empty it show warning message
                        service.errorBox(context,
                            "Fields must not empty please provide valid email and password !");
                      }
                    },
                    child: const Text("Register"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: ((context) =>
                              const LoginPage(title: "Login Page")),
                        ),
                      );
                    },
                    child: const Text("Already have an account ?"),
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
