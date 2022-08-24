import 'dart:io';

import 'package:chat_app/widgets/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var _isLoading = false;
  final firebaseAuth = FirebaseAuth.instance;

  void submitForm(
      {String? emailAddress,
      String? userName,
      String? password,
      File? imgFile,
      bool? isLogin}) async {
    try {
      UserCredential authResult;
      if (isLogin!) {
        setState(() {
          _isLoading = true;
        });
        // after sign user in auth result will contain user credential that's we use later
        authResult = await firebaseAuth.signInWithEmailAndPassword(
            email: emailAddress!, password: password!);
        print(authResult);
      } else {
        setState(() {
          _isLoading = true;
        });

        authResult = await firebaseAuth.createUserWithEmailAndPassword(
            email: emailAddress!, password: password!);
        print(authResult);

        /**
         * here we create a bucket to store our data with name 'user_image'
         * and then store user image with a name of the user  id to unique
         * */

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child('${authResult.user!.uid}.jpg');
        if (imgFile != null) {
          await ref.putFile(imgFile).whenComplete(() => null);
        }
        // here we get user image url as string
        final imgUrl = await ref.getDownloadURL();
        // when creating new user is done we will saving his username , email and his image url in our firestore database
        // in collection 'user' in document 'userid' in collection with this data
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': authResult.user!.email,
          'imgUrl': imgUrl
        });
        // after this will( setState) to close circular indicator in auth form
        // setState(() {
        //   _isLoading = false;
        // });
      }
    } on FirebaseAuthException catch (exception) {
      setState(() {
        _isLoading = false;
      });
      var errorMessage = 'an error has occurred .please check your credential';
      if (exception.message != null) {
        errorMessage = exception.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(submitForm, _isLoading),
    );
  }
}
