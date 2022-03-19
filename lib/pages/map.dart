import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  Map({Key? key, required this.position}) : super(key: key);

  LatLng position;

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  static const _initialCamaraPosition = CameraPosition(
    target: LatLng(18.502066, -69.8364374),
    zoom: 11.5,
  );

  late GoogleMapController _googleMapController;

  String nombre = '';

  Set<Marker> markers = {};

  myPlace() async {
    try {
      await placemarkFromCoordinates(
              widget.position.latitude, widget.position.longitude)
          .then(
        (value) {
          markers.add(
            Marker(
              markerId: MarkerId("1"),
              position:
                  LatLng(widget.position.latitude, widget.position.longitude),
              infoWindow: InfoWindow(
                title: value[0].name,
              ),
            ),
          );
        },
      );
    } on Exception catch (_) {
      print("Error - Map");
    }
  }

  @override
  void initState() {
    myPlace();
    super.initState();
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [
        SystemUiOverlay.top,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCamaraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.center_focus_strong,
        ),
        onPressed: () async {
          _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(
                  widget.position.latitude,
                  widget.position.longitude,
                ),
                zoom: 11,
              ),
            ),
          );
          setState(() {});
        },
      ),
    );
  }
}
