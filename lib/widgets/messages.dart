import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, streamDataSnapshot) {
          if (streamDataSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (streamDataSnapshot==null) {
            return Center(
              child: Text(
                'no message yet',
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            );
          } else {
            final chatDocs = streamDataSnapshot.data!.docs;
            return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) {
                  final userId = FirebaseAuth.instance.currentUser!.uid;
                  return MessageBubble(
                      message: chatDocs[index]['text'],
                      isMe: chatDocs[index]['userId'] == userId,
                      // here we put a key foreach message bubble this key will be
                      // the document id because every message has its own document
                      key: ValueKey(chatDocs[index].id),
                      userName: chatDocs[index]['userName'],
                      imgUrl: chatDocs[index]['imageUrl']);
                });
          }
        });
  }
}
