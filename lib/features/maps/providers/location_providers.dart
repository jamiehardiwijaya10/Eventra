import 'dart:async';

import 'package:eventra/features/maps/models/location_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class LocationNotifier extends StateNotifier<LocationState> {
  StreamSubscription<Position>? _sub;

  LocationNotifier() : super(const LocationState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    final permission = await _checkPermission();

    if(!permission) {
      state = state.copyWith(
        isLoading: false,
        error: 'Location permission denied.',
      );
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high
        )
      );
      state = state.copyWith(
        position: LatLng(pos.latitude, pos.longitude),
        heading: pos.heading,
        speed: pos.speed,
        isLoading: false,
      );

      _startStream();
          
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void _startStream(){
    _sub = 
      Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 5,
        ),
      ).listen((pos) {
        state = state.copyWith(
          position: LatLng(pos.latitude, pos.longitude),
          heading: pos.heading,
          speed: pos.speed,
        );
      });
  }

  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      try {
        permission = await Geolocator.requestPermission();
      } on PermissionRequestInProgressException {
        await Future.delayed(const Duration(milliseconds: 500));
        permission = await Geolocator.checkPermission();
      }
    }

    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

final locationProvider = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);