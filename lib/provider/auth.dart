import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class Auth with ChangeNotifier {
  String _token='';
  DateTime? _expiryDate;
  String _userId='';
  Timer? _authTimer;

  Future<void> signUp(String email, String password) async {
    // we return that wraps our http request
    // TODO: PUT YOUR URI SEGMENT
    return _authenticate(email, password, 'signUp');
  }

  String get token {
    if (_token != '' &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _expiryDate != null) {
      return _token;
    }
    return '';
  }
  String get userId{

    return _userId;
  }

  bool isAuth() {
    // return true if this condition is met
    return _token != '';
  }
// signUp
  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    try {
      final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDLV-1HCnLZUfqdrDyWQdPUx0tteCtKoME');
      final response = await http.post(
        url,
        body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true}),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _autoLogOut();
      notifyListeners();
      // Obtain shared preferences.
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
        },
      );
      prefs.setString('userData', userData);

    } catch (error) {
      throw error;
    }
  }
  Future<bool>tryToLogin()async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')!) as Map<String, Object>;
    final expiryDate = DateTime.parse((extractedUserData['expiryDate']as String));

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'] as String;
    _userId = extractedUserData['userId']as String;
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogOut();
    return true;


  }
Future<void> logUserOut()async{
    _userId='';
    _expiryDate=null;
    _token='';

   if(_authTimer!=null){
     _authTimer!.cancel();
     _authTimer=null;}

    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
  prefs.clear();


}
void _autoLogOut(){
   if(_authTimer!=null){
     _authTimer!.cancel();
   }
    final timeToExpiry=_expiryDate!.difference(DateTime.now()).inSeconds;
   _authTimer= Timer(Duration(seconds:timeToExpiry ),logUserOut);
}

  Future<void> signIn(String email, String password) async {
    // we return that wraps our http request
    // TODO: PUT YOUR URI SEGMENT
    return _authenticate(email, password, 'signInWithPassword');
  }
}
