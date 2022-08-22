import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String? id;
  final double? amount;
  final List<CartItem>? products;
  DateTime? date;

  OrderItem({this.id, this.amount, this.products, this.date});
}

class Orders with ChangeNotifier {
final String authToken;
final String userId;
  List<OrderItem> _orders = [];
  Orders(this.authToken,this._orders,this.userId);
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(double totalAmount, List<CartItem> cartProduct) async {
    var url = Uri.parse(
        'https://shop2app-1111e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final timeStamp = DateTime.now();

    final response = await http.post(url,
        body: jsonEncode({
          'totalAmount': totalAmount,
          'products': cartProduct.map((cartProd) {
            return {
              'id': cartProd.id,
              'quantity': cartProd.quantity,
              'price': cartProd.price,
              'title': cartProd.title
            };
          }).toList(),
          'date': timeStamp.toIso8601String()
        }));

    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          date: timeStamp,
          amount: totalAmount,
          products: cartProduct),
    );

    notifyListeners();
  }

  Future<void> fetchAndSetOrder() async {
    var url = Uri.parse(
        'https://shop2app-1111e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final response = await http.get(url);
    final fetchedData = jsonDecode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedItems = [];
    fetchedData.forEach((orderId, data) {
      final  products = (data['products']as List<dynamic>)
          .map((e) => CartItem(
              id: e['id'],
              price: e['price'],
              title: e['title'],
              quantity: e['quantity']))
          .toList() ;
      final order = OrderItem(
          id: orderId,
          amount: data['totalAmount'],
          date: DateTime.parse(data['date']),
          products: products);
      loadedItems.add(order);
    });
    _orders = loadedItems;
    notifyListeners();
  }
}
