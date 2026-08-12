import 'package:latlong2/latlong.dart';

class LocationState {
  final LatLng? position;
  final double? heading;
  final double? speed;
  final bool isLoading;
  final String? error;

  const LocationState({
    this.position,
    this.heading,
    this.speed,
    this.isLoading = false,
    this.error,
  });

  LocationState copyWith({
    LatLng? position,
    double? heading,
    double? speed,
    bool? isLoading,
    String? error,
  }) => LocationState(
    position: position ?? this.position,
    heading: heading ?? this.heading,
    speed: speed ?? this.speed,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}