import 'package:flutter/material.dart';
import 'package:steam_wash_admin/num_order.dart';
import 'commenting.dart';

class CustomDrawer extends StatefulWidget {
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: null,
          accountName: null,
        ),
        ListTile(
          title: Text("Show Comments"),
          leading: Icon(Icons.comment),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => Commenting()));
          },
        ),
        ListTile(
          title: Text("Number of Orders"),
          leading: Icon(Icons.confirmation_number),
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => NumOrders()));
          },
        ),
        ListTile()
      ],
    );
  }
}
