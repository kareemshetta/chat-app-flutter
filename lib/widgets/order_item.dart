import 'package:flutter/material.dart';
import '../provider/order.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  const OrderItem(this.orderItem);
  final ord.OrderItem orderItem;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.orderItem.amount!}'),
              subtitle: Text(
                DateFormat('dd/mm/yyyy  hh:mm').format(widget.orderItem.date!),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              height: _expanded
                  ? min(widget.orderItem.products!.length * 20 + 10, 100)
                  : 0,
              child: ListView(
                children: widget.orderItem.products!
                    .map(
                      (cartItem) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cartItem.title!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${cartItem.price!}  ${cartItem.quantity!} x',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          )
                        ],
                      ),
                    )
                    .toList(),
              ),
            )
          ],
        ));
  }
}
