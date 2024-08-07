import 'package:flutter/material.dart';
import 'package:google_map/Signin_demo.dart';
import 'package:google_map/address_converter.dart';
import 'package:google_map/android_map.dart';
import 'package:google_map/map_page.dart';
import 'package:google_map/map_page_2.dart';
import 'package:google_map/search_places.dart';

import 'ios_map.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: IosMap(),
    );
  }
}
