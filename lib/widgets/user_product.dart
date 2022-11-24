import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/products_provider.dart';
import '../providers/auth.dart';

class UserProduct extends StatelessWidget {
  String title;
  String imageUrl;
  String id;

  UserProduct(this.title, this.imageUrl, this.id);

  showAlertDialog(BuildContext context, String title, String id) {
        var scaffoldMessenger = ScaffoldMessenger.of(context);
        final token = Provider.of<Auth>(context,listen: false).token;
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'A1 Collection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('Are You Sure You Want To Delete $title?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.green))),
          TextButton(
              onPressed: () async {
                try {
                  Navigator.of(ctx).pop(false);
                  await Provider.of<Products>(ctx, listen: false).removeProduct(id,token);
                } catch (error) {
                  scaffoldMessenger.showSnackBar(
                    const SnackBar(
                      content: Text('Deleting fail!'),
                    ),
                  );
                }
              },
              child: const Text('Yes',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.red))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(MyApp.editProductScreen, arguments: id);
              },
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              onPressed: () => showAlertDialog(context, title, id),
              icon: Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
