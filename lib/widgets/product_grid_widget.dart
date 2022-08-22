import 'package:flutter/material.dart';
import 'package:shop_app2/provider/products.dart';
import '../widgets/product_item.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid(this.isFav);
  final bool isFav;
  @override
  Widget build(BuildContext context) {
    final productDate = Provider.of<Products>(context);
    final products = isFav?productDate.getFavourite():productDate.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 1,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
      // here we wrap each product instance with changeNotifierProvider
        //that is mean every product instance is provider


        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(
            // products[index].id!,
            // products[index].imageUrl!,
            // products[index].title!,
          ),
        );
      },
    );
  }
}
