import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sakhi/models/places.dart';

class Mapscreen extends StatefulWidget {
  const Mapscreen({
    super.key,
    this.location = const placelocation(
        latitude: 37.422, longtitude: -122.084, address: ''),
    this.isselecting = true,
  });

  final placelocation location;
  final bool isselecting;

  @override
  State<Mapscreen> createState() {
    //TODO: implement createstate
    return _MapscreenState();
  }
}

class _MapscreenState extends State<Mapscreen> {
  LatLng? _pickedlocation;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isselecting ? 'pick your location' : 'your location'),
        actions: [
          if (widget.isselecting)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap: (position) {
          setState(() {
            _pickedlocation = position;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.location.latitude,
            widget.location.longtitude,
          ),
          zoom: 16,
        ),
        markers:(_pickedlocation==null && widget.isselecting==true)?{}: {
          Marker(
            markerId: const MarkerId('m1'),
            position:
                _pickedlocation!=null?_pickedlocation!: LatLng(widget.location.latitude, widget.location.longtitude),
          ),
        },
      ),
    );
  }
}
