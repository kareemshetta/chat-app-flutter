import 'package:flutter/foundation.dart';

class CartItem {
  final String? id;
  final double? price;
  final int? quantity;
  final String? title;

  CartItem({this.id, this.price, this.quantity, this.title});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity! + 1),
      );
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
              id: DateTime.now().toString(),
              quantity: 1,
              price: price,
              title: title));
    }
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double amount = 0;
    _items.forEach((key, cartItem) {
      amount += (cartItem.quantity!) * (cartItem.price!);
    });
    return amount;
  }

  void removeCartItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId]!.quantity! > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            title: existingCartItem.title,
            price: existingCartItem.price,
            quantity: existingCartItem.quantity! - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clearAll() {
    _items = {};
    notifyListeners();
  }
}
