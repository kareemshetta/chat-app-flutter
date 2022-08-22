import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  const CartItem(
      {this.cartId, this.quantity, this.title, this.price, this.productId});
  final String? cartId;
  final String? title;
  final double? price;
  final int? quantity;
  final String? productId;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartId),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeCartItem(productId!);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are You Sure?'),
                content:
                    Text('Are you sure you want to delete item from the cart'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text('no'),
                  ),
                ],
              );
            });
      },
      child: Card(
        elevation: 6,
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                child: FittedBox(
                  child: Text(
                    price!.toString(),
                  ),
                ),
              ),
            ),
            title: Text(title!),
            subtitle: Text('total price:\$${(price! * quantity!)}'),
            trailing: Text('${quantity}x'),
          ),
        ),
      ),
    );
  }
}
