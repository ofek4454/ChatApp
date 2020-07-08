import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String _message;
  final bool sendByMe;
  final Key key;

  MessageBubble(this._message, this.sendByMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
            color: sendByMe ? Colors.green : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.circular(sendByMe ? 15 : 0),
              bottomRight: Radius.circular(sendByMe ? 0 : 15),
            ),
          ),
          child: Text(
            _message,
            style: TextStyle(
              color: Theme.of(context).accentTextTheme.headline6.color,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}
