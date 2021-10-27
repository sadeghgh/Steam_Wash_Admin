import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:steam_wash_admin/doit.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatefulWidget {
  Map<String, dynamic> data;
  String id;
  Description(this.data, this.id);

  @override
  _DescriptionState createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  String resultUserAddress = '';
  late String payment;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    payments();
    setAddress();
  }

  void payments() {
    String pay = widget.data['payment_type'];
    if (pay == '1') {
      payment = 'Payment is made in Swish';
    } else {
      payment = 'Payment is made in cash';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  widget.data['name_car'],
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  widget.data['discription_service'],
                  style: TextStyle(fontSize: 12, color: Colors.black45),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Model is: ' + widget.data['model'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Color is: ' + widget.data['color'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'Car tag is: ' + widget.data['car_tag'],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'time is: ' + widget.data['timedate'],
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.amber),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  widget.data['price'] + ' sek',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Text(
                  'address is: ' + resultUserAddress,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  payment,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black26),
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
                      // Android
                      String lt = widget.data['lat'];
                      String lg = widget.data['lng'];
                      // Android
                      var url = 'geo:$lt,$lg';
                      if (Platform.isIOS) {
                        // iOS
                        url = 'http://maps.apple.com/?ll=$lt,$lg';
                      }
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    minWidth: 250,
                    height: 45,
                    child: Text(
                      'Go To Map',
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
                      String author = widget.data['author'];
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DoIt(widget.id, author)));
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
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(Icons.call),
                      autofocus: true,
                      onPressed: () {
                        _callMe();
                      },
                      iconSize: 50,
                    ),
                    IconButton(
                      icon: Icon(Icons.sms),
                      onPressed: () {
                        _textMe();
                      },
                      autofocus: true,
                      iconSize: 50,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _callMe() async {
    // Android
    var uri = 'tel:' + widget.data['phone'];
    if (await canLaunch(uri)) {
      await launch(uri);
    }
    /*else {
      // iOS
      const uri = 'tel:001-22-060-888';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }*/
  }

  _textMe() async {
    // Android
    var uri = 'sms:' + widget.data['phone'];
    if (await canLaunch(uri)) {
      await launch(uri);
    }
    /*else {
      // iOS
      const uri = 'sms:0039-222-060-888';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        throw 'Could not launch $uri';
      }
    }*/
  }

  setAddress() async {
    double lt = double.parse(widget.data['lat']);
    double lg = double.parse(widget.data['lng']);
    final coordinates = new Coordinates(lt, lg);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    setState(() {
      resultUserAddress = ("${first.addressLine}");
    });
  }
}
