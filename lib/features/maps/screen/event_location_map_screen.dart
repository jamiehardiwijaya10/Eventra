import 'package:eventra/features/maps/providers/location_providers.dart';
import 'package:eventra/features/maps/providers/map_controller_provider.dart';
import 'package:eventra/features/maps/widgets/custom_marker.dart';
import 'package:eventra/features/maps/widgets/map_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constant/map_constants.dart';

class EventLocationMapScreen extends ConsumerStatefulWidget {
  final String eventName;
  final String eventLocation;
  final LatLng eventLatLng;

  const EventLocationMapScreen({
    super.key,
    required this.eventName,
    required this.eventLocation,
    required this.eventLatLng,
  });

  @override
  ConsumerState<EventLocationMapScreen> createState() =>
      _EventLocationMapScreenState();
}

class _EventLocationMapScreenState
    extends ConsumerState<EventLocationMapScreen> {

  @override
  Widget build(BuildContext context) {
    final isSatellite = ref.watch(isSatelliteProvider);
    final location = ref.watch(locationProvider);
    final mapController = ref.watch(mapControllerProvider);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,

            options: MapOptions(
              initialCenter: widget.eventLatLng,
              initialZoom: AppConstants.defaultZoom,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all &
                    ~InteractiveFlag.rotate,
              ),
            ),

            children: [
              TileLayer(
                urlTemplate: isSatellite
                    ? AppConstants.satelliteTileUrl
                    : AppConstants.osmTileUrl,
                userAgentPackageName:
                    'com.example.eventra',
                maxZoom: 19,
              ),

              MarkerLayer(
                markers: [
                  if (location.position != null)
                    Marker(
                      point: location.position!,
                      width: 50,
                      height: 50,
                      child: UserLocationMarker(
                        heading: location.heading ?? 0,
                      ),
                    ),

                  Marker(
                    point: widget.eventLatLng,
                    width: 60,
                    height: 70,
                    child: const DestinationMarker(),
                  ),
                ],
              ),
            ],
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              elevation: 3,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
            ),
          ),

          // Map controls
          Positioned(
            right: 16,
            bottom: 150,
            child: const MapControls(),
          ),

          // Event information
          Positioned(
            left: 16,
            right: 16,
            bottom: 30,
            child: _EventLocationCard(
              eventName: widget.eventName,
              eventLocation: widget.eventLocation,
            ),
          ),
        ],
      ),
    );
  }
}

class _EventLocationCard extends StatelessWidget {
  final String eventName;
  final String eventLocation;

  const _EventLocationCard({
    required this.eventName,
    required this.eventLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            eventName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 17,
                color: Colors.blueAccent,
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Text(
                  eventLocation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}