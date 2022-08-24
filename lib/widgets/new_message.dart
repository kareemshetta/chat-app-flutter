import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';
  void _SendMessage()async {
    FocusScope.of(context).unfocus();
   // here  we get current user id
    final userId= FirebaseAuth.instance.currentUser!.uid;
    // here we all the data that exists in users collection in specific
    // document using current userid which is document id
    // userData is document or a map
    final userData=await FirebaseFirestore.instance.collection('users').doc(userId).get();

    // by using add method we create a new document with auto created id and set this data in it
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
        'userId':userId,
        'userName':userData['userName'],
        'imageUrl':userData['imgUrl']
      },
    );
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
        // we can't put a textField inside a row because every widget of them takes all much width as it can
          // so we wrap textField inside an expanded
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text('message'),
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
             // trim() method is used for deleting all white space
              onPressed: _enteredMessage.trim().isEmpty ? null : _SendMessage,
              icon: Icon(
                Icons.send,
                color: _enteredMessage.trim().isEmpty
                    ? Colors.grey
                    : Theme.of(context).primaryColor,
              ))
        ],
      ),
    );
  }
}
