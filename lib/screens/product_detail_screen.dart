import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app2/provider/products.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);
  static const routeName = '/product-detail';
  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(id);

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title!),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // the height of appbar when it expands
            expandedHeight: 300,
          // so appbar pinned when scrolling
            pinned: true,
           //position where we put our image and app bar title
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title!,),
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(
                  loadedProduct.imageUrl!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        // widget which scroll
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(
                  height: 10,
                ),
                Text(
                  ( '\$${loadedProduct.price!}'),
                  style: TextStyle(fontSize: 20,color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  loadedProduct.description!,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  softWrap: true,
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
