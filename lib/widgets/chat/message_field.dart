import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageField extends StatefulWidget {
  @override
  _MessageFieldState createState() => _MessageFieldState();
}

class _MessageFieldState extends State<MessageField> {
  final _messageController = TextEditingController();
  var isEmpty = true;

  void _sendMessage() async {
    final user = await FirebaseAuth.instance.currentUser();
    final userData =
        await Firestore.instance.collection('users').document(user.uid).get();
    Firestore.instance.collection('chat').add(
      {
        'message': _messageController.text,
        'timeStamp': Timestamp.now(),
        'userId': user.uid,
        'username': userData['username'],
        'user_image': userData['imageURL'],
      },
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: 0,
        left: 10,
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.085,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border:
                    Border.all(color: Theme.of(context).primaryColor, width: 2),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: 'Your message here',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.trim().isNotEmpty && isEmpty) {
                    setState(() {
                      isEmpty = false;
                    });
                  }
                  if (value.trim().isEmpty && !isEmpty) {
                    setState(() {
                      isEmpty = true;
                    });
                  }
                },
                onEditingComplete: () {
                  if (_messageController.text.trim().isNotEmpty) {
                    _sendMessage();
                  }
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).primaryColor,
            onPressed: isEmpty ? null : _sendMessage,
          )
        ],
      ),
    );
  }
}
