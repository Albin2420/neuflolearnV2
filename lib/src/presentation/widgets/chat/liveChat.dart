import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:neuflo_learn/src/presentation/controller/app_startup/app_startup.dart';
import 'package:neuflo_learn/src/presentation/controller/classes/classes_controller.dart';

class LiveChat extends StatefulWidget {
  const LiveChat({
    super.key,
  });

  @override
  _LiveChatState createState() => _LiveChatState();
}

class _LiveChatState extends State<LiveChat> {
  final _controller = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final nctr = Get.find<AppStartupController>();
  final cls = Get.find<ClassesController>();

  User? _user;
  String chatId = '';
  bool isLoadingChatId = true;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((user) {
      setState(() {
        _user = user;
        chatId = cls.currentgroupChatId.value;
        if (chatId.isNotEmpty) {
          isLoadingChatId = false;
        }
      });
    });
  }

  _sendMessage({required String message}) async {
    try {
      if (message.isNotEmpty) {
        await _firestore.collection(chatId).add({
          'text': message,
          'createdAt': Timestamp.now(),
          'userId': _user?.uid,
          'studentId': nctr.appUser.value?.id,
          'profileImage': nctr.appUser.value?.imageUrl,
          'name': nctr.appUser.value?.name
        });
      }
    } catch (e) {
      log("Error:$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          padding: EdgeInsets.only(left: 21, top: 16, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Live Chat",
                style: GoogleFonts.urbanist(
                    fontWeight: FontWeight.w700, fontSize: 20),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                'Ask your doubts here',
                style: GoogleFonts.urbanist(
                    fontSize: 14, color: Color(0xff010029).withOpacity(0.5)),
              ),
            ],
          ),
        ),
        Expanded(
          child: isLoadingChatId
              ? Center(
                  child: CircularProgressIndicator(),
                ) // Show loading if chatId is still empty
              : StreamBuilder(
                  stream: _firestore
                      .collection(chatId)
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
                    if (chatSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return SizedBox();
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
                            padding: EdgeInsets.only(
                                left: 16, top: 6, bottom: 6, right: 16),
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 0, bottom: 4),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 18,
                                        backgroundImage: NetworkImage(
                                            '${chatDocs[index]['profileImage']}'),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${chatDocs[index]['name']}",
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              "${chatDocs[index]['text']}",
                                              overflow: TextOverflow.visible,
                                              style: GoogleFonts.urbanist(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w200),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
            color: Colors.white,
            child: Row(
              children: [
                SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Ask a question'),
                    onSubmitted: (value) {
                      _sendMessage(message: _controller.text);
                      _controller.clear();
                    },
                  ),
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
