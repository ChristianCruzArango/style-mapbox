import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class FullScreenMap extends StatefulWidget {
  @override
  _FullScreenMapState createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  final center = LatLng(3.4725994, -76.49099799999999);

  String selectedStyle =
      'mapbox://styles/christiancruz1991/ckh11e8uh00r019ldlfqyvw6g';

  final mapboxStyleStreem =
      'mapbox://styles/christiancruz1991/ckh11e8uh00r019ldlfqyvw6g';

  final mapboxStyleMono =
      'mapbox://styles/christiancruz1991/ckh11e8uh00r019ldlfqyvw6g';

  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/symbols/custom-icon.png");
    addImageFromUrl("networkImage", "https://via.placeholder.com/50");
  }

  /// Adds an asset image to the currently displayed style
  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, String url) async {
    var response = await get(url);
    return mapController.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: crearMapa(), floatingActionButton: botonesFlotantes());
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
            child: Icon(Icons.settings_input_svideo),
            onPressed: () {
              mapController.addSymbol(
                SymbolOptions(
                  geometry: center,
                  textField: 'Montaña creada aqui',
                  iconSize: 3,
                  iconImage: 'attraction-15',
                  textOffset: Offset(0, 2),
                ),
              );
            }),
        FloatingActionButton(
            child: Icon(Icons.zoom_in_outlined),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomIn());
            }),
        SizedBox(height: 5),
        FloatingActionButton(
            child: Icon(Icons.zoom_out_map),
            onPressed: () {
              mapController.animateCamera(CameraUpdate.zoomOut());
            }),
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              if (selectedStyle == mapboxStyleStreem) {
                selectedStyle = mapboxStyleMono;
              } else {
                selectedStyle = mapboxStyleStreem;
              }
              setState(() {});
            })
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
      styleString: selectedStyle,
      accessToken:
          'pk.eyJ1IjoiY2hyaXN0aWFuY3J1ejE5OTEiLCJhIjoiY2toMTA0dTNiMTJkbDJ3cGcxeTJkYXZvOSJ9.T7clZWS1jvnkXqlq29ODPg',
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: center, zoom: 14),
    );
  }
}
