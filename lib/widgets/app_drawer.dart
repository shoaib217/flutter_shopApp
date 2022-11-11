import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop_app/main.dart';

class AppDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Hello Shoaib!'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed('/')
          ),
          Divider(thickness: 1,color: Colors.black26,),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed(MyApp.orderScreen)
          ),
          Divider(thickness: 1,color: Colors.black26,),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Product'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed(MyApp.userProductScreen)
          ),
          Divider(thickness: 1,color: Colors.black26,),
        ],
      ),
    );
  }
}