import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../provider/order.dart' show Orders;
import '../widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);
  static const routeName = '/order-screen';

  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('you orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrder(),
          builder: (ctx, dataSnapShot) {
            if (dataSnapShot.connectionState == ConnectionState.waiting) {
              return Center(child:CircularProgressIndicator() );
            } else {
              if (dataSnapShot.error != null) {
                return Center(
                  child: Text('an error has occured'),
                );
              } else {
                return Consumer<Orders>(builder: (ctx, orderData, ch) {
                  return ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) {
                      return OrderItem(orderData.orders[i]);
                    },
                  );
                });
              }
            }
          }),
    );
  }
}
