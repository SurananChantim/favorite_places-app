import 'dart:convert';

import 'package:favorite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

import 'package:favorite_places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyB2fIcv2g54oxgv7X_lAqBexPeUcXiMKHk';
  }

  Future<void> _savePlace(double latitude, double longtitude) async {
    // ดึงข้อมูลที่อยู่จาก Google Maps API
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longtitude&key=AIzaSyB2fIcv2g54oxgv7X_lAqBexPeUcXiMKHk');
    final response = await http.get(url);
    // print('Geocoding response status: ${response.statusCode}');
    if (response.statusCode != 200) {
      // print('Error fetching geocoding data.');
      return;
    }

    final resData = json.decode(response.body);
    // print('Geocoding response data: $resData');
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(
        latitude: latitude,
        longitude: longtitude,
        address: address,
      );
      _isGettingLocation = false;
    });
    // print('Picked location: $_pickedLocation');

    widget.onSelectLocation(_pickedLocation!);
  }

  void _getCurrentLocation() async {
    // print('Starting _getCurrentLocation()');

    Location location = Location();

    // ตรวจสอบว่าบริการ location เปิดอยู่หรือไม่
    bool serviceEnabled = await location.serviceEnabled();
    print('Service enabled: $serviceEnabled');
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      print('Requested service, enabled: $serviceEnabled');
      if (!serviceEnabled) {
        print('Location service is not enabled.');
        return;
      }
    }

    // ตรวจสอบ Permission
    PermissionStatus permissionGranted = await location.hasPermission();
    // print('Permission status: $permissionGranted');
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      // print('Requested permission, granted: $permissionGranted');
      if (permissionGranted != PermissionStatus.granted) {
        // print('Location permission not granted.');
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });
    // print('Getting location...');

    // ดึงข้อมูล location
    final locationData = await location.getLocation();
    // print('Location data: $locationData');
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      // print('Failed to fetch latitude or longitude.');
      setState(() {
        _isGettingLocation = false;
      });
      return;
    }

    // print('Latitude: $lat, Longitude: $lng');
    _savePlace(lat, lng);
  }

  void _selectOnMap() async {
    final pickedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(),
      ),
    );

    if (pickedLocation == null) {
      return;
    }

    _savePlace(pickedLocation.latitude, pickedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
              onPressed: () {
                print('Get Current Location button pressed');
                _getCurrentLocation();
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.map),
              label: const Text('Select on Map'),
              onPressed: _selectOnMap,
            ),
          ],
        ),
      ],
    );
  }
}
