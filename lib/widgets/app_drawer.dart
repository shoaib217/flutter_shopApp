import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/providers/auth.dart';

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
            leading: Icon(Icons.shop,color: Colors.brown,),
            title: Text('Shop'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed('/')
          ),
          Divider(thickness: 1,color: Colors.black26,),
          ListTile(
            leading: Icon(Icons.payment,color: Colors.indigoAccent,),
            title: Text('Orders'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed(MyApp.orderScreen)
          ),
          Divider(thickness: 1,color: Colors.black26,),
          ListTile(
            leading: Icon(Icons.edit, color: Colors.blue,),
            title: Text('Manage Product'),
            onTap: () =>  Navigator.of(context).pushReplacementNamed(MyApp.userProductScreen)
          ),
          Divider(thickness: 1,color: Colors.black26,),
          ListTile(
            leading: Icon(Icons.logout,color: Colors.red,),
            title: Text('Log Out'),
            onTap: ()=> {
              Navigator.of(context).pop(),
              Navigator.of(context).pushReplacementNamed('/'),
              Provider.of<Auth>(context,listen: false).logout()
            }  
          ),
          Divider(thickness: 1,color: Colors.black26,),
        ],
      ),
    );
  }
}