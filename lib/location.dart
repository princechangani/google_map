import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:geolocator/geolocator.dart';
String latitude= "";
String longitude="";
class location extends StatefulWidget {
  const location({super.key});

  @override
  State<location> createState() => _locationState();
}

class _locationState extends State<location> {
  Position? position;
  fetchposition ()async{
    bool serviceEnabled;

    LocationPermission permission;

    serviceEnabled=await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      Fluttertoast.showToast(msg:'Location service is disabled');
    }
    permission =await Geolocator.checkPermission();
   if (permission == LocationPermission.denied) {
     permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg:'Location denied is permission ');

      }
    }
   if (permission==LocationPermission.deniedForever){
     Fluttertoast.showToast(msg:'Location denied is permission forever ');
   }
   Position currentposition = await Geolocator.getCurrentPosition();
   setState(() {
     position = currentposition ;
     latitude =currentposition.latitude.toString();
     print(latitude);
     longitude =currentposition.longitude.toString();
     print(longitude);

   });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GeoLocation'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(position ==null?'Location' : position.toString(),style: TextStyle(fontSize: 15),),
          Center(
            child: ElevatedButton(onPressed: () {
              fetchposition();

            }, child: Text('Get Location')),
          )
        ],
      ),
    );
  }
}
