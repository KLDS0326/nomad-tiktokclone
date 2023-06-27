import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class MarkerIconsPage extends GoogleMapExampleAppPage {
  final double latitude;
  final double longitude;

  const MarkerIconsPage({
    Key? key,
    required this.latitude,
    required this.longitude,
  }) : super(const Icon(Icons.image), 'Marker icons', key: key);

  @override
  Widget build(BuildContext context) {
    return MarkerIconsBody(
      latitude: latitude,
      longitude: longitude,
    );
  }
}

class MarkerIconsBody extends StatefulWidget {
  final double latitude;
  final double longitude;

  const MarkerIconsBody({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<StatefulWidget> createState() => MarkerIconsBodyState();
}

const LatLng _kMapCenter = LatLng(37.536, 126.618);
LatLng _maerkerLocation = _kMapCenter;

class MarkerIconsBodyState extends State<MarkerIconsBody> {
  GoogleMapController? controller;
  BitmapDescriptor? _markerIcon;
  late double latitude;
  late double longitude;

  @override
  void initState() {
    super.initState();
    _maerkerLocation = LatLng(widget.latitude, widget.longitude);
  }

  @override
  Widget build(BuildContext context) {
    _createMarkerImageFromAsset(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 300.0,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _maerkerLocation.latitude == 0.0 &&
                        _maerkerLocation.longitude == 0.0
                    ? _kMapCenter
                    : _maerkerLocation,
                zoom: 14.0,
              ),
              markers: <Marker>{_createMarker()},
              onMapCreated: (controller) => _onMapCreated,
              onTap: _onMapTap,
            ),
          ),
        )
      ],
    );
  }

  Marker _createMarker() {
    if (_markerIcon != null) {
      return Marker(
          markerId: const MarkerId('marker_1'),
          position: _maerkerLocation,
          icon: _markerIcon!,
          draggable: true,
          onDragEnd: (newPosition) {
            setState(() {
              _maerkerLocation = newPosition;
            });
          });
    } else {
      return const Marker(
        markerId: MarkerId('marker_1'),
        position: _kMapCenter,
      );
    }
  }

  Future<void> _createMarkerImageFromAsset(BuildContext context) async {
    if (_markerIcon == null) {
      final ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size.square(48));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, 'assets/red_square.png')
          .then(_updateBitmap);
    }
  }

  void _updateBitmap(BitmapDescriptor bitmap) {
    setState(() {
      _markerIcon = bitmap;
    });
  }

  void _onMapCreated(GoogleMapController controllerParam) {
    setState(() {
      controller = controllerParam;
    });
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _maerkerLocation = position;
    });
  }
}
