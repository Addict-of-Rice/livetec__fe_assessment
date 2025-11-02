import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/api/outbreak_api.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/types/outbreak.dart';

class MapOverlay {
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Polygon> polygons = {};
  Set<Polyline> polylines = {};
}

class MapService {
  MapOverlay overlay = MapOverlay(); // TODO: handle caching to offload backend

  void addOutbreakOverlay(List<Outbreak> outbreaks, Color color, double hue) {
    for (Outbreak outbreak in outbreaks) {
      if (outbreak.zoneShape.isNotEmpty) {
        for (List<LatLng> shape in outbreak.zoneShape) {
          overlay.polygons.add(
            Polygon(
              polygonId: PolygonId(outbreak.id),
              points: shape,
              fillColor: color.withValues(alpha: 0.8),
              strokeColor: color,
              strokeWidth: 1,
              onTap: () => {},
            ),
          );
        }
      }

      if (outbreak.zoneDiameter > 0) {
        overlay.circles.add(
          Circle(
            circleId: CircleId(outbreak.id),
            center: outbreak.location,
            radius: outbreak.zoneDiameter / 2,
            fillColor: color.withValues(alpha: 0.8),
            strokeColor: color,
            strokeWidth: 1,
            onTap: () => {},
          ),
        );
      } else {
        overlay.markers.add(
          Marker(
            markerId: MarkerId(outbreak.id),
            position: outbreak.location,
            icon: BitmapDescriptor.defaultMarkerWithHue(hue),
            onTap: () => {},
          ),
        );
      }
    }
  }

  Future<MapOverlay> getMapOverlay(List<DateTime> dates) async {
    overlay = MapOverlay();

    List<Outbreak> activeOutbreaks = await getActiveOutbreaks(
      dates.first,
      dates.last,
      null,
    );
    List<Outbreak> historicalOutbreaks = await getHistoricalOutbreaks(
      dates.first,
      dates.last,
      null,
    );

    List<Outbreak> poultryOutbreaks = activeOutbreaks
        .where((outbreak) => outbreak.type == 'Poultry')
        .toList();
    List<Outbreak> cattleOutbreaks = activeOutbreaks
        .where((outbreak) => outbreak.type == 'Cattle')
        .toList();

    addOutbreakOverlay(
      poultryOutbreaks,
      AppColors.orangeBulletPoint,
      BitmapDescriptor.hueOrange,
    );
    addOutbreakOverlay(
      cattleOutbreaks,
      AppColors.blueBulletPoint,
      BitmapDescriptor.hueBlue,
    );
    addOutbreakOverlay(
      historicalOutbreaks,
      AppColors.magentaBulletPoint,
      BitmapDescriptor.hueMagenta,
    );

    return overlay;
  }
}
