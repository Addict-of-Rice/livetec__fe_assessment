import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/types/map_overlay.dart';

class CustomMap extends StatefulWidget {
  final MapType mapType;
  final void Function(LatLng) onTap;
  final MapOverlay mapOverlay;

  const CustomMap({
    super.key,
    required this.mapType,
    required this.onTap,
    required this.mapOverlay,
  });

  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  late GoogleMapController mapController;

  // Default center: London
  final LatLng _center = const LatLng(51.5074, -0.1278);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: true,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
      myLocationButtonEnabled: true,
      myLocationEnabled: false,
      mapType: widget.mapType,
      zoomControlsEnabled: false,
      onTap: widget.onTap,
      markers: widget.mapOverlay.markers,
      circles: widget.mapOverlay.circles,
      polygons: widget.mapOverlay.polygons,
      polylines: widget.mapOverlay.polylines,
    );
  }
}
