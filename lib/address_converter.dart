import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class AddressConverter extends StatefulWidget {
  const AddressConverter({super.key});

  @override
  State<AddressConverter> createState() => _AddressConverterState();
}

class _AddressConverterState extends State<AddressConverter> {
  String showAddress = '';
  String showCoor = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geocoding Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(showCoor),
            ElevatedButton(
              onPressed: () async {
                final double latitude = 25.2048;
                final double longitude = 55.2708;
                List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
                List<Location> locations = await locationFromAddress("surat");
                var first = placemarks.first;
                setState(() {
                  showCoor= locations.first.longitude.toString();
                  showAddress = '${first.street}, ${first.locality}, ${first.country}';
                });
              },
              child: Text('Convert'),
            ),
          ],
        ),
      ),
    );
  }
}
