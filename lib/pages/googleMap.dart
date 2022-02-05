  import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'package:PonyGold/globals.dart' as globals;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controller = Completer();
  List<Marker> marker = [
    Marker(
        markerId:
            MarkerId(LatLng(Get.arguments[0], Get.arguments[1]).toString()),
        position: LatLng(Get.arguments[0], Get.arguments[1]))
  ];
  double latitude = 0.0;
  double longitude = 0.0;
  var geolacator = geolocator.Geolocator();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(Get.arguments[0], Get.arguments[1]),
    zoom: 18.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(Get.arguments[0], Get.arguments[1]),
      tilt: 59.440717697143555,
      zoom: 19.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Корзина"),
          centerTitle: true,
          backgroundColor: globals.blue,
        ),
        body: GoogleMap(
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapType: MapType.hybrid,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          markers: Set.from(marker),
          onTap: handleTab,
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 30,
              ),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Color(0xFFFFFFFF)),
                onPressed: () {
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        'Отмена',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30, top: 15, bottom: 15),
              height: 48,
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(primary: globals.blue),
                onPressed: () {
                  globals.latitude = latitude;
                  globals.longitude = longitude;
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        'Подтвердить',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  handleTab(LatLng tappedPoint) {
    setState(() {
      latitude = tappedPoint.latitude;
      longitude = tappedPoint.longitude;
      marker = [];
      marker.add(
        Marker(
            markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
    });
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    setState(() {
      marker = [];
      marker.add(
        Marker(
            markerId:
                MarkerId(LatLng(Get.arguments[0], Get.arguments[1]).toString()),
            position: LatLng(Get.arguments[0], Get.arguments[1])),
      );
    });
  }
}
