import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {Key? key, this.message, this.isMe, this.userName, this.imgUrl})
      : super(key: key);
  final String? message;
  final bool? isMe;
  final String? userName;
  final String? imgUrl;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment:
              //  MainAxisAlignment.end at the right (is me)
              isMe! ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              width: 150,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
              decoration: BoxDecoration(
                color: isMe!
                    ? Theme.of(context).colorScheme.secondary
                    : Colors.grey,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10),
                    bottomRight:
                        isMe! ? Radius.circular(0) : Radius.circular(10),
                    bottomLeft:
                        isMe! ? Radius.circular(10) : Radius.circular(0)),
              ),
              child: Column(
                crossAxisAlignment:
                    isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    textAlign: isMe! ? TextAlign.end : TextAlign.start,
                    userName!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isMe!
                            ? Theme.of(context).textTheme.headline1!.color
                            : Colors.black),
                  ),
                  Text(
                    message!,
                    textAlign: isMe! ? TextAlign.end : TextAlign.start,
                    style: TextStyle(
                        color: isMe!
                            ? Theme.of(context).textTheme.headline1!.color
                            : Colors.black),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(right:isMe!? 130:null,
            left:isMe!?null:130 ,
            child: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl!),

        ))
      ],
    );
    ;
  }
}
