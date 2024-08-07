import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AndroidMap extends StatefulWidget {
  const AndroidMap({super.key});

  @override
  State<AndroidMap> createState() => _AndroidMapState();
}

class _AndroidMapState extends State<AndroidMap> {
  GoogleMapController? _controller;

  final LatLng _initialPosition = LatLng(37.7749, -122.4194);
  final Set<Marker> _markers = {};
  late var _mapController;
  Position? _currentPosition;
  LatLng? _destinationPosition;
  final Set<Polyline> _polylines = {};

  void initState() {
    _fetchCurrentPosition();
    super.initState();

  }

  void _fetchCurrentPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
      _destinationPosition = LatLng(22.7749, 70.4194);
      _markers.add(Marker(
        markerId: MarkerId('currentPosition'),
        position: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      ));
      _markers.add(Marker(
        markerId: MarkerId('destinationPosition'),
        position: _destinationPosition!,
      ));
      _fetchRoute();
    });
  }

  void _fetchRoute() async {
    PolylineResult? result = await Repo.getRouteBetweenTwoPoints(
      start: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
      end: _destinationPosition!,
      color: Colors.blue,
    );

    if (result!.points.isNotEmpty) {
      setState(() {
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: result.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
          color: Colors.blue,
          width: 5,
        ));
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Maps in Flutter'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          :GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude,_currentPosition!.longitude),
          zoom: 10,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
        },
      ),
    );
  }
}
