import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('timeStamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final chatDocs =
                  snapshot.data.documents as List<DocumentSnapshot>;
              if (chatDocs == null || chatDocs.length == 0) {
                return Container();
              }

              return ListView.builder(
                reverse: true,
                itemCount: chatDocs.length,
                itemBuilder: (ctx, i) => MessageBubble(
                  message: chatDocs[i]['message'],
                  userName: chatDocs[i]['username'],
                  userImage: chatDocs[i]['user_image'],
                  time: DateFormat('HH:mm').format(DateTime.parse(
                      chatDocs[i]['timeStamp'].toDate().toString())),
                  sendByMe: chatDocs[i]['userId'] == userSnapshot.data.uid,
                  key: ValueKey(chatDocs[i].documentID),
                ),
              );
            },
          );
        });
  }
}
