import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var _latitude = "";
  var _longitude = "";
  var _altitude = "";
  var _speed = "";
  var _address = "";

  Future<void> _updateposition() async {
    Position pos = await _determineposition();
    List newpos = await placemarkFromCoordinates(pos.latitude, pos.longitude);
    setState(() {
        _latitude = pos.latitude.toString();
        _longitude = pos.longitude.toString();
        _altitude = pos.altitude.toString();
        _speed = pos.speed.toString();

        _address = newpos[0].toString();
    });
  }

  Future<Position> _determineposition() async {
    bool serviceenable;
    LocationPermission permission;
    serviceenable = await Geolocator.isLocationServiceEnabled();
    if (!serviceenable) {
      return Future.error('Location Permission is denied');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location Permission is denied forever');
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('FindMyAddress'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('My address is: ' + _address),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateposition,
        child: const Icon(Icons.search),
      ),
    );
  }
}
