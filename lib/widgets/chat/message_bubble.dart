import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String userName;
  final String userImage;
  final String time;
  final bool sendByMe;
  final Key key;

  MessageBubble(
      {this.message,
      this.userName,
      this.userImage,
      this.time,
      this.sendByMe,
      this.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment:
          sendByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Stack(
          overflow: Overflow.visible,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              margin: EdgeInsets.all(screenWidth * 0.025),
              width: screenWidth * 0.6,
              decoration: BoxDecoration(
                color: sendByMe ? Colors.green : Theme.of(context).accentColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(sendByMe ? 15 : 0),
                  bottomRight: Radius.circular(sendByMe ? 0 : 15),
                ),
              ),
              child: Column(
                crossAxisAlignment: sendByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline6.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SelectableText(
                    message,
                    style: TextStyle(
                      color: Theme.of(context).accentTextTheme.headline6.color,
                      fontSize: 18,
                    ),
                    textAlign: sendByMe ? TextAlign.end : TextAlign.start,
                  ),
                  Container(
                    width: double.infinity,
                    alignment:
                        sendByMe ? Alignment.bottomLeft : Alignment.bottomRight,
                    child: Text(
                      time,
                      style: TextStyle(
                        color:
                            Theme.of(context).accentTextTheme.headline6.color,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: sendByMe ? -screenWidth * 0.015 : null,
              right: !sendByMe ? -screenWidth * 0.015 : null,
              top: -screenWidth * 0.015,
              child: CircleAvatar(
                radius: screenWidth * 0.05,
                backgroundImage: NetworkImage(userImage),
              ),
            )
          ],
        ),
      ],
    );
  }
}
