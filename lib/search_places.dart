import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SearchPlaces extends StatefulWidget {
  const SearchPlaces({super.key});

  @override
  State<SearchPlaces> createState() => _SearchPlacesState();
}

class _SearchPlacesState extends State<SearchPlaces> {
  TextEditingController _controller = TextEditingController();
  String _sessionToken = "122344";
  List<dynamic> _placeList=[];
  var uuid = Uuid();
  @override
  void initState() {

    super.initState();
    _controller.addListener((){
      onChange();
    });
  }
  void onChange() {
    if (_sessionToken == null){
      setState(() {
        _sessionToken = uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion (String input)async{
    String kPLACES_API_KEY = "AIzaSyD5KT2GjTnovLF-JbbPLEf5kpvzIEvRWXc";
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';
 var response = await http.get(Uri.parse(request));
 var data = response.body.toString();
 print(data);
if (response.statusCode==200){
_placeList = jsonDecode(response.body.toString())['predictions'];
}else{
  throw Exception("failed");
}
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Google Search places Api'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search places'
              ),

            )
          ],
        ),
      ) ,
    );
  }
}
