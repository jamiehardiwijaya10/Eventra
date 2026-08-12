import 'package:eventra/core/constant/map_constants.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

final mapControllerProvider = Provider<MapController>((ref) {
  final controller = MapController();
  ref.onDispose(controller.dispose);
  return controller;
});

final isSatelliteProvider = StateProvider<bool>((ref) => false);

extension MapControllerx on MapController {
  void moveSmooth(LatLng center, {double zoom = AppConstants.defaultZoom}) {
    move(center, zoom);
  }
}