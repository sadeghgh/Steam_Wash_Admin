import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NumOrders extends StatefulWidget {
  @override
  _NumOrdersState createState() => _NumOrdersState();
}

class _NumOrdersState extends State<NumOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('user').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
            ),
            body: Padding(
                padding: EdgeInsets.all(10),
                child: ListView(
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data()! as Map<String, dynamic>;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                      elevation: 6,
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        title: Column(
                          children: [
                            Text(data['phone'] + ' :'),
                            Text('Number of orders is: ' + data['orders'])
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                )));
      },
    );
  }
}
