import 'package:google_maps_flutter/google_maps_flutter.dart';

LatLng parseLatLngFromLocation(Map jsonLocation) {
  return LatLng(
    (jsonLocation['latitude'] as num).toDouble(),
    (jsonLocation['longitude'] as num).toDouble(),
  );
}

List<List<LatLng>> parseLatLngFromZoneShapes(List jsonZoneShape) {
  return jsonZoneShape.map<List<LatLng>>((shape) {
    if (shape is List) {
      return shape
          .map<LatLng>(
            (point) => LatLng(
              // Note: backend is returning [longitude, latitude]
              (point[1] as num).toDouble(),
              (point[0] as num).toDouble(),
            ),
          )
          .toList();
    }
    throw Exception('Invalid shape format: $shape');
  }).toList();
}
