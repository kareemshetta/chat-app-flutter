import 'package:flutter/material.dart';
import '../provider/auth.dart';
import 'package:provider/provider.dart';
import '../screens/order_scree.dart';
import '../helpers/custom_route.dart';
class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('welcome to our shop'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
             // Navigator.of(context).pushReplacementNamed('/order-screen');
              Navigator.of(context).push(CustomRoute(child:OrderScreen() ),);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('user-product-screen');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('log out'),
            onTap: () {
             Navigator.of(context).pop();
             Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context,listen: false).logUserOut();
            },
          )
        ],
      ),
    );
  }
}
