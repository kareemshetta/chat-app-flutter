import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app2/provider/order.dart';
import '../provider/cart.dart';
import '../widgets/care_item.dart' as cr;

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);
  static const routeName = '/cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
    );

    final totalAmount = cart.totalAmount;
    Provider.of<Orders>(context).fetchAndSetOrder();
    return Scaffold(
        appBar: AppBar(
          title: Text('your cart'),
        ),
        body: Column(
          children: [
            Card(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      'total',
                      style: TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '\$ ${totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).primaryTextTheme.subtitle1,
                      ),
                    ),
                    OrderButton(totalAmount: totalAmount, cart: cart)
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: cart.itemsCount,
                  itemBuilder: (ctx, index) {
                    return cr.CartItem(
                      title: cart.items.values.toList()[index].title,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                      cartId: cart.items.values.toList()[index].id,
                      productId: cart.items.keys.toList()[index],
                    );
                  }),
            )
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.totalAmount,
    required this.cart,
  }) : super(key: key);

  final double totalAmount;
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.totalAmount <= 0 || isLoading)
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.totalAmount, widget.cart.items.values.toList());
                setState(() {
                  isLoading = false;
                });
                widget.cart.clearAll();
              },
        child: isLoading ? CircularProgressIndicator() : Text('ORDER NOW'));
  }
}
