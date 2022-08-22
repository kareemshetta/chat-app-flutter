import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';
import '../screens/product_detail_screen.dart';
import '../provider/product.dart';
import '../provider/auth.dart';

class ProductItem extends StatelessWidget {
  // const ProductItem(this.id, this.imageUrl, this.title);
  // final String id;
  // final String imageUrl;
  // final String title;
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final items = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            product.title!,
            textAlign: TextAlign.center,
            softWrap: true,
          ),
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                product.isFavourite! ? Icons.favorite : Icons.favorite_outline,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () async {
                await product.toggleFavourite(auth.token, auth.userId);
              },
            ),
          ),
          trailing: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                items.addItem(product.id!, product.title!, product.price!);

                final snackBar = SnackBar(
                  content: Text('adding new item to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      items.removeSingleItem(product.id!);
                    },
                  ),
                );
                // we do this so we can interact with new SnackBar don't wait the last one to finish its duration
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }),
        ),
        // the child of the grid tile
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Hero(tag: product.id!,
            child: FadeInImage(
                placeholder: AssetImage(
                  'assets/images/product-placeholder.png',
                ),
                image: NetworkImage(
                  product.imageUrl!,
                ),
                fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
