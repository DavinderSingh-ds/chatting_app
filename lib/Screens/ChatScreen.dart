// ignore_for_file: file_names

import 'package:chatting_app/Helper/FirebaseHelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

var loginUser = FirebaseAuth.instance.currentUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //user value will be online
      updateUser("online");
    } else {
      //user will be offline
      updateUser("offline");
    }
  }

  updateUser(status) async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(loginUser!.uid)
        .update({'status': status});
  }

  Service service = Service();

  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  TextEditingController msg = TextEditingController();

  Map? map;
  String? userdata;

  //for current user
  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      //if user not empty it assign to login user
      loginUser = user;
    }
  }

  userData() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(loginUser!.uid)
        .get()
        .then((value) {
      setState(() {
        map = value.data();
        userdata = map?['status'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    userData();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loginUser!.email.toString()),
            Text(userdata.toString()),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              service.signOut(context);
              updateUser("offline");
              //now here we remove that email from the key when user click logout button
              SharedPreferences pref = await SharedPreferences.getInstance();
              pref.remove("email");
              // it will remove user email when user click logout button
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Other User Status"),
          Container(
            color: Colors.amber,
            height: 50,
            width: double.infinity,
            child: StreamBuilder<QuerySnapshot>(
                //now we can order the message that sent message show in the bottom
                stream:
                    FirebaseFirestore.instance.collection("Users").snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, i) {
                        QueryDocumentSnapshot x = snapshot.data!.docs[i];
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, top: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //if the user as self ir will not show his status and here is showing only
                              //other user
                              loginUser!.email == x['email']
                                  ? const Text("")
                                  : Column(
                                      children: [
                                        const CircleAvatar(
                                          radius: 14,
                                          backgroundColor: Colors.green,
                                        ),
                                        Text(x["name"]),
                                      ],
                                    ),
                            ],
                          ),
                        );
                      });
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Messages',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          //displaying messages
          Expanded(
            child: Container(
              color: Colors.white,
              child: const ShowMessages(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.blue, width: 0.5),
                    ),
                  ),
                  child: TextField(
                    controller: msg,
                    decoration: const InputDecoration(
                      hintText: "Enter Message.....",
                    ),
                  ),
                ),
              ),
              IconButton(
                  onPressed: () {
                    if (msg.text.isNotEmpty) {
                      storeMessage.collection("Messages").doc().set(
                        {
                          "messages": msg.text.trim(),
                          "user": loginUser!.email.toString(),
                          "time": DateTime.now()
                        },
                      );
                      msg.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class ShowMessages extends StatelessWidget {
  const ShowMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        //now we can order the message that sent message show in the bottom
        stream: FirebaseFirestore.instance
            .collection("Messages")
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              primary: true,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                return ListTile(
                  title: Column(
                    //if user is self then chat showsin end else other user chat shows in start
                    crossAxisAlignment: loginUser!.email == x['user']
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: loginUser!.email == x['user']
                              ? Colors.blue.withOpacity(0.2)
                              : Colors.amber.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(x['messages']),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "User: " + x['user'],
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
