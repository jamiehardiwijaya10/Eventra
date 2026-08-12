import 'package:eventra/features/maps/navigation/models/route_state.dart';
import 'package:eventra/features/maps/providers/location_providers.dart';
import 'package:eventra/features/maps/providers/map_controller_provider.dart';
import 'package:eventra/features/maps/providers/route_provider.dart';
import 'package:eventra/features/maps/providers/search_providers.dart';
import 'package:eventra/features/maps/widgets/custom_marker.dart';
import 'package:eventra/features/maps/widgets/map_controls.dart';
import 'package:eventra/features/maps/widgets/route_info_panel.dart';
import 'package:eventra/features/maps/widgets/search_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constant/map_constants.dart';

class MapScreen extends ConsumerStatefulWidget {
  final String? eventLocation;
  final String? eventName;
  final LatLng? eventLatlNg;
  
  const MapScreen({
    super.key,
    this.eventLocation,
    this.eventName,
    this.eventLatlNg,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  LatLng get _defaultCenter =>
    widget.eventLatlNg ??
    const LatLng(-6.901380528085498, 107.6197135848428);

  bool _mapReady = false;

  void _onMapReady () {
    setState(() => _mapReady = true);
    
    if (widget.eventLatlNg != null) {
      ref
        .read(mapControllerProvider)
        .moveSmooth(
          widget.eventLatlNg!,
          zoom: AppConstants.defaultZoom,
        );
      return;
    }

    final pos = ref.read(locationProvider).position;
    
    if(pos != null) {
      ref
        .read(mapControllerProvider)
        .moveSmooth(pos, zoom: AppConstants.defaultZoom);
    }
  }

  void _handleNavigatingCamera(RouteState route) {
    if (!_mapReady) return;
    if (route.status == NavigationStatus.navigating && route.animatedMarkerPos != null) {
      ref
        .read(mapControllerProvider)
        .moveSmooth(route.animatedMarkerPos!, zoom: AppConstants.defaultZoom);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final location = ref.watch(locationProvider);
    final isSatellite = ref.watch(isSatelliteProvider);
    final mapController = ref.watch(mapControllerProvider);
    final destination = ref.watch(selectedPlaceProvider);
    final route = ref.watch(routeProvider);

    ref.listen(locationProvider, (prev, next){
      if (!_mapReady) return;

      if(prev?.position == null && next.position != null) {
        ref
          .read(mapControllerProvider)
          .moveSmooth(next.position!, zoom: AppConstants.defaultZoom);
      }
    });

    ref.listen(routeProvider, (_, next) => _handleNavigatingCamera(next));

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: 
                widget.eventLatlNg ??
                location.position ?? 
                _defaultCenter,
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
              
              if (route.routePoints.isNotEmpty)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: route.routePoints,
                      strokeWidth: 8,
                      color: Colors.black.withAlpha(20),
                    ),

                    Polyline(
                      points: route.routePoints,
                      strokeWidth: 5,
                      color: const Color(0xFF1565C0),
                      strokeCap: StrokeCap.round,
                      strokeJoin: StrokeJoin.round,
                    ),

                    if (route.status == NavigationStatus.navigating && route.currentSegmentIndex > 0)
                      Polyline(
                        points: route.routePoints
                          .take(route.currentSegmentIndex)
                          .toList(),
                        strokeWidth: 5,
                        color: Colors.green,
                        strokeCap: StrokeCap.round,
                      ),
                  ],
                ),

              MarkerLayer(
                markers: [
                  if (widget.eventLocation != null)
                    Marker(
                      point: widget.eventLatlNg!,
                      width: 50,
                      height: 70,
                      child: const DestinationMarker(),
                    ),

                  if (location.position != null)
                    Marker(
                      point: location.position!,
                      width: 50,
                      height: 50,
                      child: UserLocationMarker(heading: location.heading ?? 0,),
                    ),
                    
                  if (destination != null && route.status != NavigationStatus.navigating)
                    Marker(
                      point: destination.latLng,
                      width: 50,
                      height: 70,
                      child: const DestinationMarker(),
                    ),

                  if (route.animatedMarkerPos != null && route.status == NavigationStatus.navigating)
                    Marker(
                      point: route.animatedMarkerPos!,
                      width: 44,
                      height: 44,
                      child: NavigationMarker(
                        bearing: route.animatedMarkerBearing ?? 0,
                      ),
                    ),
                ],
              ),
            ],
          ),

          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution("OpenStreetMap contributors"),
            ],
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: const SearchBarWidget(),
          ),

          Positioned(right: 16, bottom: 200, child: const MapControls(),),

          if (route.status == NavigationStatus.loading)
            const Positioned(
              bottom: 120,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2,),
                        ),
                        
                        SizedBox(width: 12,),
                        Text('Finding best route...')
                      ],
                    )
                  ),
                ),
              ),
            ),

          if (location.error != null) 
            Positioned(
              top: MediaQuery.of(context).padding.top + 80,
              left: 16,
              right: 16,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_rounded, color: Colors.white,),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Text(
                          location.error!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom,
            left: 16,
            right: 16,
            child: const RouteInfoPanel(),
          ),

          if (route.error != null)
            Positioned(
              bottom: 100,
              left: 16,
              right: 16,
              child: Material(
                borderRadius: BorderRadius.circular(12),
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    route.error!,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}

