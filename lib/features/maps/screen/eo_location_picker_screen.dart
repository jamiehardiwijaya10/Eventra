import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:eventra/features/maps/widgets/custom_marker.dart';

class SelectedEventLocation {
  final String address;
  final double latitude;
  final double longitude;

  const SelectedEventLocation({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class EventLocationPickerScreen extends StatefulWidget {
  const EventLocationPickerScreen({
    super.key,
  });

  @override
  State<EventLocationPickerScreen> createState() =>
      _EventLocationPickerScreenState();
}

class _EventLocationPickerScreenState
    extends State<EventLocationPickerScreen> {

  LatLng selectedLocation =
      const LatLng(-6.901380528085498, 107.6197135848428);

  String selectedAddress = "Select a location";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xffF7F8FA),
        title: const Text("Select Event Location"),
      ),

      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 15,
              onTap: (_, point) {
                setState(() {
                  selectedLocation = point;
                });

                // Placholdeh, will connect nominatim l8r
              },
            ),

            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.eventra',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 50,
                    height: 70,
                    child: const DestinationMarker(),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  context,
                  SelectedEventLocation(
                    address: selectedAddress,
                    latitude: selectedLocation.latitude,
                    longitude: selectedLocation.longitude,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text("Confirm Location"),
            ),
          ),
        ],
      ),
    );
  }
}