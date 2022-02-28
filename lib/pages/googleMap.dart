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
    Marker(markerId: MarkerId(LatLng(Get.arguments[0], Get.arguments[1]).toString()), position: LatLng(Get.arguments[0], Get.arguments[1]))
  ];
  double latitude = 0.0;
  double longitude = 0.0;
  var geolacator = geolocator.Geolocator();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  int _markerIdCounter = 0;
  Completer<GoogleMapController> _mapController = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(Get.arguments[0], Get.arguments[1]),
    zoom: 18.0,
  );

  static final CameraPosition _kLake =
      CameraPosition(bearing: 192.8334901395799, target: LatLng(Get.arguments[0], Get.arguments[1]), tilt: 59.440717697143555, zoom: 19.0);

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
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            // onMapCreated: (GoogleMapController controller) {
            //   _controller.complete(controller);
            // },
            markers: Set<Marker>.of(_markers.values),
            onMapCreated: _onMapCreated,
            onTap: handleTab,
            onCameraMove: (CameraPosition position) {
              if (_markers.length > 0) {
                MarkerId markerId = MarkerId(_markerIdVal());
                Marker marker = _markers[markerId]!;
                Marker updatedMarker = marker.copyWith(
                  positionParam: position.target,
                );
                setState(() {
                  _markers[markerId] = updatedMarker;
                });
              }
            }),
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
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
        Marker(markerId: MarkerId(tappedPoint.toString()), position: tappedPoint),
      );
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _mapController.complete(controller);
    if (_kGooglePlex != null) {
      MarkerId markerId = MarkerId(_markerIdVal());
      LatLng position = LatLng(Get.arguments[0], Get.arguments[1]);
      Marker marker = Marker(
        markerId: markerId,
        position: position,
        draggable: false,
      );
      setState(() {
        _markers[markerId] = marker;
      });

      Future.delayed(Duration(seconds: 1), () async {
        GoogleMapController controller = await _mapController.future;
        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: position,
              zoom: 17.0,
            ),
          ),
        );
      });
    }
  }

  String _markerIdVal({bool increment = false}) {
    String val = 'marker_id_$_markerIdCounter';
    if (increment) _markerIdCounter++;
    return val;
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
    setState(() {
      marker = [];
      marker.add(
        Marker(markerId: MarkerId(LatLng(Get.arguments[0], Get.arguments[1]).toString()), position: LatLng(Get.arguments[0], Get.arguments[1])),
      );
    });
  }
}
