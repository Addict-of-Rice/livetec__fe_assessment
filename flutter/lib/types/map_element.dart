import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapElementCategory {
  currentPoultryOutbreaks,
  currentCattleOutbreaks,
  historicalOutbreaks,
  wildbirdDeaths,
  farms,
  wildbirdMigrations,
}

// MapElement is an intermediary object between backend response data and the MapOverlay for the purpose of front-end filtering without requesting a new response.
class MapElement {
  final MapElementCategory category;
  final DateTime minDate;
  final DateTime maxDate;
  final Marker? firstMarker;
  final Marker? secondMarker;
  final Circle? circle;
  final Polyline? polyline;
  final Set<Polygon>? polygons;

  MapElement({
    required this.category,
    required this.minDate,
    required this.maxDate,
    this.firstMarker,
    this.secondMarker,
    this.circle,
    this.polyline,
    this.polygons,
  });
}
