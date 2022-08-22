import 'package:flutter/material.dart';
import 'package:shop_app2/screens/cart_screen.dart';
import 'package:shop_app2/widgets/main_drawer.dart';

import '../widgets/product_grid_widget.dart';
import '../widgets/badge.dart';
import '../provider/cart.dart';
import 'package:provider/provider.dart';
import '../provider/products.dart';

enum ShowFavourite { all, fav }

class ProductOverviewScreen extends StatefulWidget {
  ProductOverviewScreen({Key? key}) : super(key: key);
  static const routeName = '/productoverview';

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showFav = false;
  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    setState(() {});
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          PopupMenuButton(
            onSelected: (ShowFavourite isFav) {
              setState(() {
                if (isFav == ShowFavourite.all) {
                  showFav = false;
                } else {
                  showFav = true;
                }
              });
            },
            icon: Icon(Icons.more_vert_outlined),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                  child: Text('Only Favourite'), value: ShowFavourite.fav),
              PopupMenuItem(child: Text('ShowAll'), value: ShowFavourite.all),
            ],
          ),
          Consumer<Cart>(
            builder: (ctx, cart, ch) =>
                Badge(child: ch!, value: cart.itemsCount.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFav),
    );
  }
}
