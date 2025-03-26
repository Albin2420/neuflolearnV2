import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';

class LiveChats extends StatefulWidget {
  const LiveChats({super.key});

  @override
  _LiveChatsState createState() => _LiveChatsState();
}

class _LiveChatsState extends State<LiveChats> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final nctr = Get.find<AppStartupController>();

  User? _user;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
      });
    });
  }

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      await _firestore.collection('chats').add({
        'text': _controller.text,
        'createdAt': Timestamp.now(),
        'userId': _user?.uid,
        'studentId': nctr.appUser.value?.id,
        'profileImage': nctr.appUser.value?.imageUrl,
        'name': nctr.appUser.value?.name
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _firestore
                .collection('chats')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
              if (chatSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final chatDocs = chatSnapshot.data!.docs;
              if (chatDocs.isEmpty) {
                return SizedBox();
              } else {
                return ListView.separated(
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5,
                  ),
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                      padding: EdgeInsets.only(left: 16, top: 6, bottom: 6),
                      color: Colors.white,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 4, bottom: 4),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundImage: NetworkImage(
                                      '${chatDocs[index]['profileImage']}'),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${chatDocs[index]['name']}",
                                  style: GoogleFonts.urbanist(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 45),
                            child: Text(
                              "${chatDocs[index]['text']}",
                              overflow: TextOverflow.visible,
                              style: GoogleFonts.urbanist(
                                  fontSize: 16, fontWeight: FontWeight.w200),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        if (_user != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        if (_user == null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text("Please sign in to chat")),
          ),
      ],
    );
  }
}
