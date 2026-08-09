import 'dart:convert';

import 'package:eventra/core/constant/map_constants.dart';
import 'package:eventra/features/maps/navigation/models/route_state.dart';
import 'package:eventra/features/maps/providers/location_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

import 'package:latlong2/latlong.dart';

class RouteNotifier extends StateNotifier<RouteState> {
  final Ref _ref;
  Timer? _animTimer;

  RouteNotifier(this._ref) : super(const RouteState());

  Future<void> fetchRoute() async {
    final location = _ref.read(selectedPlaceProvider);

    if (location == null || destination == null) return;

    state = state.copyWith(status: NavigationStatus.loading, error:null);

    try {
      final url = 
        '${AppConstants.osrmBaseUrl}/${location.longitude},${location.latitude};'
        '${destination.latLng.longitude},${destination.LatLng.latitude}'
        '?overview=full&geometries=geojson&steps=true';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) throw Exception('OSRM Error');

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final route = (json['routes'] as List).first as Map<String, dynamic>;
      final coords = (route['geometry']['coordinates'] as List)
        .map(
          (c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble()),
        ).toList();

      state = state.copyWith(
        routePoints: coords,
        animatedMarkerPos: coords.first,
        status: NavigationStatus.ready,
        distanceMeters: (route['distance'] as num).toDouble(),
        durationSeconds: (route['duration'] as num).toDouble(),
        currentSegmentIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(
        status: NavigationStatus.idle,
        error: 'Could not load route. Check connection.',
      );
    }
  }

  void startNavigation() {
    if (state.routePoints.isEmpty) return;
    _animTimer?.cancel();

    final points = state.routePoints;
    final totalSteps = AppConstants.markerAnimSteps;

    final interpolated = _interpolatePath(points, totalSteps);
    int step = 0;
    
    state = state.copyWith(status: NavigationStatus.navigating);

    _animTimer = Timer.periodic(AppConstants.markerAnimDuration, (timer) {
      if (step >= interpolated.length - 1) {
        timer.cancel();
        state = state.copyWith(
          animatedMarkerPos: interpolated.last,
          status: NavigationStatus.arrived,
        );
      return;
      }

      final current = interpolated(step);
      final next = 
    });
  }
}
