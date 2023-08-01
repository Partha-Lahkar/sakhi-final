import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:sakhi/models/places.dart';
import 'package:sakhi/screens/map.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({
    super.key,
    required this.onSelectlocation,
  });
  final void Function(placelocation location) onSelectlocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  placelocation? _pickedLocation;
  var _isgettinglocation = false;

  String get locationimage {
    if (_pickedLocation == null) {
      return '';
    }
    final lat = _pickedLocation!.latitude;
    final lng = _pickedLocation!.longtitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyAzgJDP4mNENbI30wcgi2Mvea2H7kKIJjU';
  }

  Future<void> _saveplace(double latitude, double longtitude) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longtitude&key=AIzaSyAzgJDP4mNENbI30wcgi2Mvea2H7kKIJjU');
    final response = await http.get(url);
    final resdata = json.decode(response.body);
    final adress = resdata['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = placelocation(
          latitude: latitude, longtitude: longtitude, address: adress);
      _isgettinglocation = false;
    });
    widget.onSelectlocation(_pickedLocation!);
  }

  void _getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isgettinglocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _saveplace(lat, lng);
  }

  void _selectonmap() async {
    final pickedlocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const Mapscreen(),
      ),
    );

    if (pickedlocation == null) {
      return;
    }
    _saveplace(pickedlocation.latitude,pickedlocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewcontent = Text(
      'no location choosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onBackground,
          ),
    );
    if (_pickedLocation != null) {
      previewcontent = Image.network(
        locationimage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    if (_isgettinglocation) {
      previewcontent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 157,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          )),
          child: previewcontent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getcurrentlocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get current location'),
            ),
            TextButton.icon(
                onPressed:_selectonmap,
                icon: const Icon(Icons.map),
                label: const Text('select on map')),
          ],
        )
      ],
    );
  }
}
