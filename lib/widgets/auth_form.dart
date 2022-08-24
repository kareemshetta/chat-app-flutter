import 'dart:io';

import 'package:flutter/material.dart';

import '../picker/image_picker.dart';

//enum Auth { login, signup }

class AuthForm extends StatefulWidget {
  const AuthForm(this.onSubmitForm, this.isLoading);

  final bool isLoading;
  final void Function(
      {String? emailAddress,
      String? userName,
      String? password,
      File? imgFile,
      bool? isLogin})? onSubmitForm;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  // Auth _authState = Auth.login;
  var _isLogin = true;
  final _formKey = GlobalKey<FormState>();
  final emailFocusNode = FocusNode();
  final userNameFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  //final _formData = {'email': '', 'password': '', 'userName': ''};
  String _emailAddress = '';
  String _password = '';
  String _userName = '';
  File? imgFile;

  // this function we'll pass a reference to imagePreview so we can pass it's image file
  //and use it to submit form
  void _picImage(File imageFile) {
    imgFile = imageFile;
  }

  void _tryToSubmit() {
    final isValid = _formKey.currentState!.validate();
    if (!_isLogin && imgFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('please pick an image '),
        backgroundColor: Theme.of(context).errorColor,
      ));
      // so the code below  can't be executed until picking an image
      return;
    }

    if (isValid) {
      _formKey.currentState!.save();
      // so soft keyboard will be close when we submit form
      FocusScope.of(context).unfocus();

      widget.onSubmitForm!(
        emailAddress: _emailAddress.trim(),
        password: _password.trim(),
        userName: _userName.trim(),
        imgFile: imgFile,
        isLogin: _isLogin,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        elevation: 6,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!_isLogin) ImagePreview(_picImage),
                TextFormField(
                  // we put this ValueKey so every textformfield knows its data even if we change auth data
                  key: const ValueKey('email'),
                  keyboardType: TextInputType.url,
                  decoration: InputDecoration(
                    label: Text('Email Address'),
                  ),
                  focusNode: emailFocusNode,
                  validator: (value) {
                    if (!value!.contains('@') || value.isEmpty) {
                      return 'please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _emailAddress = value!;
                  },
                  onFieldSubmitted: (value) {
                    if (_isLogin) {
                      FocusScope.of(context).requestFocus(userNameFocusNode);
                    } else {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    }
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('userName'),
                    decoration: InputDecoration(
                      label: Text('Username'),
                    ),
                    focusNode: userNameFocusNode,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'please enter at least 4 characters  ';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _userName = value!;
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(passwordFocusNode);
                    },
                  ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  focusNode: passwordFocusNode,
                  decoration: InputDecoration(
                    label: Text('password'),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter a password.';
                    }
                    if (value.length < 7) {
                      return 'please enter a long password';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _password = value!;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                widget.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: _tryToSubmit,
                        child: Text(_isLogin ? 'login' : 'register'),
                      ),
                TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child:
                        Text(_isLogin ? 'create new account' : 'login instead'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
