import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../provider/products.dart';
import '../widgets/user_product_widget.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = 'user-product-screen';
  Future<void> _refreshProduct(BuildContext context) async {
    // we have to listen false
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-screeen');
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () {
                  return _refreshProduct(context);
                },
                child: Consumer<Products>(
                  builder: (ctx, products, ch) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    child: ListView.builder(
                      itemCount: products.items.length,
                      itemBuilder: (ctx, index) {
                        return Column(
                          children: [
                            UserProductItem(
                              id: products.items[index].id,
                              title: products.items[index].title,
                              imageUrl: products.items[index].imageUrl,
                            ),
                            Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
