import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map/repo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IosMap extends StatefulWidget {
  const IosMap({super.key});

  @override
  State<IosMap> createState() => _IosMapState();
}

class _IosMapState extends State<IosMap> {
  GoogleMapController? _controller;

  final Set<Marker> _markers = {};
  Position? _currentPosition;
  LatLng? _destinationPosition;
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _fetchCurrentPosition();
  }

  void _fetchCurrentPosition() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permissions are permanently denied, we cannot request permissions.');
      }

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

        // Move camera to current position
        if (_controller != null) {
          _controller!.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
            ),
          );
        }
      });
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  void _fetchRoute() async {
    if (_currentPosition != null && _destinationPosition != null) {
      try {
        PolylineResult? result = await Repo.getRouteBetweenTwoPoints(
          start: LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
          end: _destinationPosition!,
          color: Colors.blue,
        );

        if (result == null) {
          throw Exception('Failed to fetch route.');
        }

        if (result.points.isNotEmpty) {
          setState(() {
            _polylines.add(Polyline(
              polylineId: PolylineId('route'),
              points: result.points.map((e) => LatLng(e.latitude, e.longitude)).toList(),
              color: Colors.blue,
              width: 5,
            ));
          });
        } else {
          throw Exception('No route found.');
        }
      } catch (e) {
        print("Error fetching route: $e");
      }
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
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude
          ),
          zoom: 10,
        ),
        markers: _markers,
        polylines: _polylines,
        onMapCreated: (controller) {
          setState(() {
            _controller = controller;
          });
          if (_currentPosition != null) {
            _controller!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
