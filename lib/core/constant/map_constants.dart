class AppConstants {
  static const String osrmBaseUrl = 'https://router.project-osrm.org/route/v1/driving';

  static const String nominatingBaseUrl = 'https://nominatim.openstreetmap.org';

  static const String osmTileUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String satelliteTileUrl = 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}';

  //Anims Duration
  static const Duration markerAnimDuration = Duration(milliseconds: 50);
  static const Duration cameraAnimDuration = Duration(milliseconds: 600);
  static const Duration routeDrawDuration = Duration(milliseconds: 1200);

  static const int markerAnimSteps = 200;

  static const double defaultZoom = 15.0;
  static const double routeZoom = 13.0;
}
  