import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steam_wash_admin/description.dart';
import 'package:steam_wash_admin/my_list.dart';
import 'package:steam_wash_admin/my_map.dart';
import 'drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MainMaterial());
}

class MainMaterial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int page = 0;
  bool home = true, list = false;
  Widget returnPage(int page) {
    Widget s = MyMap();
    if (page == 0) {
      s = MyMap();
    } else if (page == 1) {
      s = MyList();
    }
    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      drawer: SizedBox(
        child: Drawer(
          child: SafeArea(child: CustomDrawer()),
        ),
      ),
      body: returnPage(page),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
        shape: CircularNotchedRectangle(),
        notchMargin: 10.0,
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: home == false
                  ? Icon(Icons.home, color: Colors.blueGrey)
                  : Icon(Icons.home, color: Colors.white),
              onPressed: () {
                setState(() {
                  page = 0;
                  home = true;
                  list = false;
                });
              },
            ),
            IconButton(
              icon: list == false
                  ? Icon(Icons.list, color: Colors.blueGrey)
                  : Icon(Icons.list, color: Colors.white),
              onPressed: () {
                setState(() {
                  page = 1;
                  home = false;
                  list = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
