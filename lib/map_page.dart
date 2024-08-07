import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import 'location_handler.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late var _mapController;
  Position? _currentPosition;
  LatLng? _destinationPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? currenPos;


  @override
  void initState() {
    super.initState();
    _requestPermissions();
    _fetchCurrentPosition();

  }

  void _requestPermissions() async {

    await Permission.location.request();

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

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps Route Example'),
      ),
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          zoom: 13,
        ),
        markers: _markers,
        polylines: _polylines,
        myLocationEnabled: true,
      ),
    );
  }
}