import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:steam_wash_admin/description.dart';
import 'drawer.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Marker? marker;
  LatLng _latLng = LatLng(59.330678551220515, 18.071957153518493);

  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collectionGroup('requestUser')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasData) {
            for (var point in snapshot.data!.docs) {
              if ((point['doit'] == '0')) {
                String id = point.id;
                double lat = double.parse(point['lat']);
                double lng = double.parse(point['lng']);
                LatLng latLng = new LatLng(lat, lng);
                marker = Marker(
                    markerId: MarkerId(point.id),
                    position: latLng,
                    infoWindow: InfoWindow(
                        title: point['name_car'],
                        snippet: point['discription_service'],
                        onTap: () {
                          Map<String, dynamic> data =
                              point.data()! as Map<String, dynamic>;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Description(data, id)));
                        }));
                _markers.add(marker!);
              }
            }
          }

          return Scaffold(
              body: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: 10.0,
            ),
            markers: _markers,
          ));
        });
  }
}
