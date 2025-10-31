import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const LivetecApp());
}

class LivetecApp extends StatelessWidget {
  const LivetecApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Livetec Flutter App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF2a403b)),
        useMaterial3: true,
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;

  // Default center: UK
  final LatLng _center = const LatLng(54.5, -3.0);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Livetec Map'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: _center, zoom: 5.0),
        myLocationButtonEnabled: true,
        myLocationEnabled: false,
        mapType: MapType.normal,
      ),
    );
  }
}
