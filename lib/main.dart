import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app2/screens/auth_screen.dart';
import 'package:shop_app2/screens/edite_product_screen.dart';
import 'package:shop_app2/screens/user_product_screen.dart';

import './screens/splash_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/order_scree.dart';
import '../screens/product_detail_screen.dart';
import '../screens/product_overview_page.dart';

import './provider/products.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './provider/auth.dart';

import './helpers/custom_route.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  // ChangeNotifierProxyProvider<MyModel, MyChangeNotifier>(
  // // may cause the state to be destroyed involuntarily
  // update: (_, myModel, myNotifier) => MyChangeNotifier(myModel: myModel),
  // child: ...
  // );
  //

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (ctx) => Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts!.items == null ? [] : previousProducts.items,
                auth.userId),
            create: (ctx) => Products('', [], ''),
          ),
          ChangeNotifierProvider(create: (ctx) => Cart()),
          ChangeNotifierProxyProvider<Auth, Orders>(
            update: (ctx, auth, previousOrders) => Orders(
                auth.token,
                previousOrders!.orders == null ? [] : previousOrders.orders,
                auth.userId),
            create: (ctx) => Orders('', [], ''),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop App',
            theme: ThemeData(
                colorScheme: ColorScheme.light().copyWith(
                    primary: Colors.purple, secondary: Colors.deepOrange),
                primarySwatch: Colors.purple,
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android:CustomPageTransitionBuilder(),
                  TargetPlatform.iOS:CustomPageTransitionBuilder(),
                }),
                fontFamily: 'Lato'),
            // you mustn't use home where initial route
            home: auth.isAuth()
                ? ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryToLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                                : AuthScreen()),
            routes: {
              ProductOverviewScreen.routeName: (ctx) => ProductOverviewScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen()
            },
          ),
        ));
  }
}
