import 'package:eventra/features/maps/providers/location_providers.dart';
import 'package:eventra/features/maps/providers/map_controller_provider.dart';
import 'package:eventra/features/maps/widgets/custom_marker.dart';
import 'package:eventra/features/maps/widgets/map_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constant/map_constants.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  static const LatLng _defaultCenter = LatLng(-6.901380528085498, 107.6197135848428);

  bool _mapReady = false;

  void _onMapReady () {
    setState(() => _mapReady = true);

    final pos = ref.read(locationProvider).position;
    if(pos != null) {
      ref
        .read(mapControllerProvider)
        .moveSmooth(pos, zoom: AppConstants.defaultZoom);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final isSatellite = ref.watch(isSatelliteProvider);
    final mapController = ref.watch(mapControllerProvider);

    ref.listen(locationProvider, (prev, next){
      if (!_mapReady) return;

      if(prev?.position == null && next.position != null) {
        ref
          .read(mapControllerProvider)
          .moveSmooth(next.position!, zoom: AppConstants.defaultZoom);
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: location.position ?? _defaultCenter,
              initialZoom: AppConstants.defaultZoom,
              onMapReady: _onMapReady,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: isSatellite
                  ? AppConstants.satelliteTileUrl
                  : AppConstants.osmTileUrl,
                userAgentPackageName: 'com.example.osm_flutter.app',
                maxZoom: 19,
              ),

              MarkerLayer(
                markers: [
                  if (location.position != null)
                    Marker(
                      point: location.position!,
                      width: 50,
                      height: 50,
                      child: UserLocationMarker(heading: location.heading ?? 0,),
                    ),
                    
                  if (location.position != null)
                    Marker(
                      point: LatLng(-6.901380528085498, 107.6197135848428),
                      width: 80,
                      height: 80,
                      child: const ColoredBox(color: Colors.red, child: SizedBox(width: 50, height: 50,),) 
                    )
                ],
              )
            ],
          ),

          Positioned(right: 16, bottom: 200, child: const MapControls(),),
        ],
      ),
    );
  }
}

