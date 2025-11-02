import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/outbreak_api.dart';
import 'package:livetec_flutter_app/api/wildbird_deaths_api.dart';
import 'package:livetec_flutter_app/components/bullet_point.dart';
import 'package:livetec_flutter_app/components/calendar.dart';
import 'package:livetec_flutter_app/components/icon_button.dart';
import 'package:livetec_flutter_app/components/map.dart';
import 'package:livetec_flutter_app/components/map_type_button.dart';
import 'package:livetec_flutter_app/components/standard_container.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';
import 'package:livetec_flutter_app/types/death.dart';
import 'package:livetec_flutter_app/types/map_element.dart';
import 'package:livetec_flutter_app/types/map_overlay.dart';
import 'package:livetec_flutter_app/types/outbreak.dart';

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
  MapType _mapType = MapType.normal;

  bool _showFilters = false;
  bool _showMapLayers = false;
  bool _showCalendar = false;

  List<DateTime> _dateRange = [DateTime.now()];
  DateTime? _currentDate;
  MapOverlay _mapOverlay = MapOverlay();

  Set<MapElement> _mapElementSet = {};
  final List<MapElementCategory> _hiddenCategories = [];

  @override
  void initState() {
    super.initState();
    _getMapElementSet();
  }

  Future<void> _getMapElementSet() async {
    Set<MapElement> newMapElementSet = {};

    void addOutbreak(
      MapElementCategory category,
      List<Outbreak> outbreaks,
      Color color,
      double hue,
    ) {
      for (Outbreak outbreak in outbreaks) {
        Set<Polygon>? polygons;
        if (outbreak.zoneShape.isNotEmpty) {
          polygons = {};
          for (List<LatLng> shape in outbreak.zoneShape) {
            polygons.add(
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

        Circle? circle;
        if (outbreak.zoneDiameter > 0) {
          circle = Circle(
            circleId: CircleId(outbreak.id),
            center: outbreak.location,
            radius: outbreak.zoneDiameter / 2,
            fillColor: color.withValues(alpha: 0.8),
            strokeColor: color,
            strokeWidth: 1,
            onTap: () => {},
          );
        }

        Marker marker = Marker(
          markerId: MarkerId(outbreak.id),
          position: outbreak.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          onTap: () => {},
        );

        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        newMapElementSet.add(
          MapElement(
            category: category,
            minDate: outbreak.started,
            maxDate: outbreak.ended == null ? today : outbreak.ended!,
            marker: marker,
            circle: circle,
            polygons: polygons,
          ),
        );
      }
    }

    void addDeath(List<Death> deaths, Color color, double hue) {
      for (Death death in deaths) {
        newMapElementSet.add(
          MapElement(
            category: MapElementCategory.wildbirdDeaths,
            minDate: death.date,
            maxDate: death.date,
            marker: Marker(
              markerId: MarkerId(death.id),
              position: death.location,
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              onTap: () => {},
            ),
          ),
        );
      }
    }

    List<Outbreak> activeOutbreaks = await getActiveOutbreaks(
      _dateRange.first,
      _dateRange.last,
      null,
    );
    List<Outbreak> historicalOutbreaks = await getHistoricalOutbreaks(
      _dateRange.first,
      _dateRange.last,
      null,
    );
    List<Death> wildbirdDeaths = await getWildbirdDeaths(
      _dateRange.first,
      _dateRange.last,
    );

    List<Outbreak> poultryOutbreaks = activeOutbreaks
        .where((outbreak) => outbreak.type == 'Poultry')
        .toList();
    List<Outbreak> cattleOutbreaks = activeOutbreaks
        .where((outbreak) => outbreak.type == 'Cattle')
        .toList();

    addOutbreak(
      MapElementCategory.currentPoultryOutbreaks,
      poultryOutbreaks,
      AppColors.orangeBulletPoint,
      BitmapDescriptor.hueOrange,
    );
    addOutbreak(
      MapElementCategory.currentCattleOutbreaks,
      cattleOutbreaks,
      AppColors.blueBulletPoint,
      BitmapDescriptor.hueBlue,
    );
    addOutbreak(
      MapElementCategory.historicalOutbreaks,
      historicalOutbreaks,
      AppColors.magentaBulletPoint,
      BitmapDescriptor.hueMagenta,
    );

    addDeath(
      wildbirdDeaths,
      AppColors.yellowBulletPoint,
      BitmapDescriptor.hueYellow,
    );

    setState(() => _mapElementSet = newMapElementSet);
    _getMapOverlay();
  }

  void _getMapOverlay() {
    MapOverlay newMapOverlay = MapOverlay();
    for (MapElement element in _mapElementSet) {
      if (!_hiddenCategories.contains(element.category) &&
          (_currentDate == null ||
              ((_currentDate!.isAtSameMomentAs(element.minDate) ||
                      _currentDate!.isAfter(element.minDate)) &&
                  (_currentDate!.isBefore(element.maxDate) ||
                      _currentDate!.isAtSameMomentAs(element.maxDate))))) {
        if (element.marker != null) {
          newMapOverlay.markers.add(element.marker!);
        }
        if (element.circle != null) {
          newMapOverlay.circles.add(element.circle!);
        }
        if (element.polyline != null) {
          newMapOverlay.polylines.add(element.polyline!);
        }
        if (element.polygons != null) {
          newMapOverlay.polygons.addAll(element.polygons!);
        }
      }
    }
    setState(() => _mapOverlay = newMapOverlay);
  }

  Timer? _timer;
  bool _isDateRangePlaying = false;

  void playRangeSlider() {
    void onTick(DateTime? date) {
      setState(() {
        _currentDate = date;
      });
      _getMapOverlay();
    }

    if (_currentDate == null) {
      _timer?.cancel();
      DateTime timerDate = _dateRange.first;
      onTick(timerDate);

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isDateRangePlaying) {
          if (timerDate.isAtSameMomentAs(_dateRange.last)) {
            _isDateRangePlaying = false;
            timer.cancel();
            onTick(null);
          } else {
            timerDate = timerDate.add(const Duration(days: 1));
            onTick(timerDate);
          }
        }
      });
    }
  }

  void getPreviousDayInRangeSlider() {
    setState(() {
      _isDateRangePlaying = false;

      if (_currentDate != null && _currentDate!.isAfter(_dateRange.first)) {
        _currentDate = _currentDate!.subtract(const Duration(days: 1));
      }
    });
    _getMapOverlay();
  }

  void getNextDayInRangeSlider() {
    setState(() {
      _isDateRangePlaying = false;

      if (_currentDate != null && _currentDate!.isBefore(_dateRange.last)) {
        _currentDate = _currentDate!.add(const Duration(days: 1));
      }
    });
    _getMapOverlay();
  }

  void cancelRangeSlider() {
    setState(() {
      _currentDate = null;
      _isDateRangePlaying = false;
    });
    _timer?.cancel();
  }

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
          CustomMap(
            mapType: _mapType,
            onTap: (LatLng position) => setState(() {
              _showFilters = false;
              _showMapLayers = false;
            }),
            mapOverlay: _mapOverlay,
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
                                  color: AppColors.orangeBulletPoint,
                                ),
                                BulletPoint(
                                  text: 'Current Cattle Outbreaks',
                                  color: AppColors.blueBulletPoint,
                                ),
                                BulletPoint(
                                  text: 'Historical Outbreaks',
                                  color: AppColors.magentaBulletPoint,
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
                  dates: _dateRange,
                  onValueChanged: (newDates) {
                    cancelRangeSlider();
                    setState(() => _dateRange = newDates);
                    _getMapElementSet();
                  },
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
                              onTap: () {
                                if (!_isDateRangePlaying) {
                                  playRangeSlider();
                                }

                                setState(() {
                                  _isDateRangePlaying = !_isDateRangePlaying;
                                });
                              },
                              child: Container(
                                color: AppColors.tertiary,
                                height: double.infinity,
                                width: 60,
                                child: Icon(
                                  _isDateRangePlaying
                                      ? Icons.pause
                                      : Icons.play_arrow,
                                  size: 36,
                                  color: AppColors.neutral,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: getPreviousDayInRangeSlider,
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
                              onTap: getNextDayInRangeSlider,
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
                              _currentDate != null
                                  ? DateFormat(
                                      'MMMM dd yyyy',
                                    ).format(_currentDate!)
                                  : _dateRange.length <= 1
                                  ? DateFormat(
                                      'MMMM dd yyyy',
                                    ).format(_dateRange[0])
                                  : '${DateFormat('MMM dd yyyy').format(_dateRange.first)} -  ${DateFormat('MMM dd yyyy').format(_dateRange.last)}',
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
