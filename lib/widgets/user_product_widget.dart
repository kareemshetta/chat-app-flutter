import 'package:flutter/material.dart';
import '../provider/products.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  const UserProductItem({this.title, this.imageUrl, this.id});
  final String? title;
  final String? imageUrl;
  final String? id;
  @override
  Widget build(BuildContext context) {
final scaffold=ScaffoldMessenger.
of(context);
    return ListTile(
      title: Text(title!),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl!),
      ),
      trailing:
          // without container will make an error we cannot use row inside listTile
          Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/edit-screeen', arguments: id);
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () async {
                try {
                  await Provider.of<Products>(
                    context,listen: false
                  ).removeProduct(id!);
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('deleting failed'),
                    ),
                  );
                }
              },
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).errorColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
