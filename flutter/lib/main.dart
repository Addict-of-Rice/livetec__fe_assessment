import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/components/bullet_point.dart';
import 'package:livetec_flutter_app/components/calendar.dart';
import 'package:livetec_flutter_app/components/icon_button.dart';
import 'package:livetec_flutter_app/components/map_type_button.dart';
import 'package:livetec_flutter_app/components/standard_container.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
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
  final LatLng _center = const LatLng(51.5074, -0.1278);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  MapType _mapType = MapType.normal;

  bool _showFilters = false;
  bool _showMapLayers = false;
  bool _showCalendar = false;

  DateTime _date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Outbreak Map',
          textAlign: TextAlign.center,
          style: AppTextStyles.screenTitle,
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: Stack(
        children: [
          GoogleMap(
            mapToolbarEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 10.0),
            myLocationButtonEnabled: true,
            myLocationEnabled: false,
            mapType: _mapType,
            zoomControlsEnabled: false,
            onTap: (LatLng position) => setState(() {
              _showFilters = false;
              _showMapLayers = false;
            }),
            // markers: ,
          ),

          AnimatedScale(
            alignment: Alignment(-0.9, -0.85),
            scale: _showFilters ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: StandardContainer(
              child: Row(
                children: [
                  SizedBox(width: 36),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Filters', style: AppTextStyles.containerTitle),
                        Divider(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          AnimatedScale(
            alignment: Alignment(0.9, -0.85),
            scale: _showMapLayers ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: StandardContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 8,
                          children: [
                            Text(
                              'Map Layers',
                              style: AppTextStyles.containerTitle,
                            ),
                            Divider(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              spacing: 32,
                              children: [
                                BulletPoint(
                                  text: 'Current Poultry Outbreaks',
                                  color: AppColors.redBulletPoint,
                                ),
                                BulletPoint(
                                  text: 'Current Cattle Outbreaks',
                                  color: AppColors.blueBulletPoint,
                                ),
                                BulletPoint(
                                  text: 'Historical Outbreaks',
                                  color: AppColors.redBulletPoint,
                                ),
                                BulletPoint(
                                  text: 'Wildbird Deaths',
                                  color: AppColors.yellowBulletPoint,
                                ),
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      SizedBox(width: 36),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      MapTypeButton(
                        selectedMapType: _mapType,
                        mapType: MapType.normal,
                        image: 'assets/default.png',
                        onTap: () => setState(() {
                          _mapType = MapType.normal;
                        }),
                      ),
                      MapTypeButton(
                        selectedMapType: _mapType,
                        mapType: MapType.terrain,
                        image: 'assets/terrain.png',
                        onTap: () => setState(() {
                          _mapType = MapType.terrain;
                        }),
                      ),
                      MapTypeButton(
                        selectedMapType: _mapType,
                        mapType: MapType.satellite,
                        image: 'assets/satellite.png',
                        onTap: () => setState(() {
                          _mapType = MapType.satellite;
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 64,
            right: 8,
            child: AnimatedScale(
              alignment: Alignment.bottomRight,
              scale: _showCalendar ? 1 : 0,
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 300),
              child: Container(
                width: 300,
                height: 300,
                color: AppColors.primary,
                child: Calendar(
                  date: _date,
                  onValueChanged: (dates) => setState(() => _date = dates[0]),
                ),
              ),
            ),
          ),

          Positioned(
            top: 8,
            left: 0,
            child: AnimatedOpacity(
              opacity: _showMapLayers ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CustomIconButton(
                icon: Icons.filter_alt_outlined,
                onPressed: () {
                  if (!_showMapLayers) {
                    setState(() {
                      _showFilters = !_showFilters;
                      _showMapLayers = false;
                    });
                  }
                },
              ),
            ),
          ),

          Positioned(
            top: 8,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showFilters ? 0 : 1,
              duration: const Duration(milliseconds: 300),
              child: CustomIconButton(
                icon: Icons.layers_outlined,
                onPressed: () {
                  if (!_showFilters) {
                    setState(() {
                      _showMapLayers = !_showMapLayers;
                      _showFilters = false;
                    });
                  }
                },
              ),
            ),
          ),

          Positioned(
            bottom: 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 16,
                child: Row(
                  spacing: 16,
                  children: [
                    SizedBox(
                      height: 36,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Row(
                          children: [
                            GestureDetector(
                              child: Container(
                                color: AppColors.tertiary,
                                height: double.infinity,
                                width: 60,
                                child: Icon(
                                  Icons.play_arrow,
                                  size: 36,
                                  color: AppColors.neutral,
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                color: AppColors.primary,
                                height: double.infinity,
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.neutral,
                                    ),
                                    child: Icon(
                                      Icons.skip_previous,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                color: AppColors.primary,
                                height: double.infinity,
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.neutral,
                                    ),
                                    child: Icon(
                                      Icons.skip_next,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () =>
                            setState(() => _showCalendar = !_showCalendar),
                        child: Container(
                          height: 24,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('MMMM dd yyyy').format(_date),
                              style: AppTextStyles.inverted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
