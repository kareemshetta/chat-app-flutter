import 'package:flutter/material.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

import 'package:shop_app2/models/http_exception.dart';

class Product with ChangeNotifier{
  final String? id;
  final String? imageUrl;
  final String? title;
  final double? price;
  bool? isFavourite;
  final String? description;

  Product({
    this.id,
    this.imageUrl,
    this.title,
    this.price,
    this.isFavourite = false,
    this.description,
  });


 Future<void>toggleFavourite(String authToken,String userId)async{
   var url = Uri.parse(
       'https://shop2app-1111e-default-rtdb.firebaseio.com/userFavourites/$userId/$id.json?auth=$authToken');
   final oldFavourite=isFavourite;
   isFavourite=!isFavourite!;
    notifyListeners();
 try{
   final response= await http.put(url,body:json.encode(isFavourite!),);
   if(response.statusCode>400){
     isFavourite=oldFavourite;
     notifyListeners();

   }
 }catch(error){
   isFavourite=oldFavourite;
   notifyListeners();
 }


  }
}
