import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:steam_wash_admin/main.dart';

class DoIt extends StatefulWidget {
  String id;
  String author;

  DoIt(this.id, this.author);

  @override
  _DoItState createState() => _DoItState();
}

class _DoItState extends State<DoIt> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  late int rand, cunt, order, cunt2;
  late String p, ord;

  setTimer() {
    Duration duration = Duration(seconds: 3);
    Timer(duration, () {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainMaterial()),
          (Route<dynamic> route) => false);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    randomCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                elevation: 5,
                child: MaterialButton(
                  onPressed: () async {
                    doIt();
                  },
                  minWidth: 250,
                  height: 45,
                  child: Text(
                    'Doing This Work',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Material(
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                elevation: 5,
                child: MaterialButton(
                  onPressed: () async {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(widget.author)
                        .collection('requestUser')
                        .doc(widget.id)
                        .delete();

                    var snackBar = SnackBar(
                      content: Text('The record was successfully deleted'),
                      action: SnackBarAction(
                          label: 'undo',
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MainMaterial()),
                                (Route<dynamic> route) => false);
                          }),
                    );
                    scaffoldKey.currentState!.showSnackBar(snackBar);
                    setTimer();
                  },
                  minWidth: 250,
                  height: 45,
                  child: Text(
                    'Delete This Work',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void randomCode() {
    int min = 10000;
    int max = 1000000;
    var rn = new Random();
    rand = min + rn.nextInt(max - min);
  }

  getUser() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.author)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          Map<String, dynamic>? user =
              documentSnapshot.data() as Map<String, dynamic>?;

          order = int.parse(user!['orders']);
          cunt = int.parse(user['counter']);
          order = order + 1;
          cunt2 = cunt + 1;
        });
      }
    });
  }

  doIt() {
    if (cunt == 5) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(widget.author)
          .update({'counter': '0', 'code': 'nul', 'orders': order.toString()});
      setDoit();
    } else if (cunt == 4) {
      FirebaseFirestore.instance.collection('user').doc(widget.author).update({
        'counter': '5',
        'code': rand.toString(),
        'orders': order.toString()
      });
      setDoit();
    } else {
      FirebaseFirestore.instance.collection('user').doc(widget.author).update({
        'counter': cunt2.toString(),
        'code': 'nul',
        'orders': order.toString()
      });
      setDoit();
    }
  }

  setDoit() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(widget.author)
        .collection('requestUser')
        .doc(widget.id)
        .update({'doit': '1'}).then((value) {
      var snackBar = SnackBar(
        content: Text('mission accomplished'),
        action: SnackBarAction(
            label: 'undo',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MainMaterial()),
                  (Route<dynamic> route) => false);
            }),
      );
      scaffoldKey.currentState!.showSnackBar(snackBar);
      setTimer();
    });
  }
}
