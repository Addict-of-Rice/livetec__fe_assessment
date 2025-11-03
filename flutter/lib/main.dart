import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:livetec_flutter_app/api/farms_api.dart';
import 'package:livetec_flutter_app/api/outbreak_api.dart';
import 'package:livetec_flutter_app/api/wildbird_deaths_api.dart';
import 'package:livetec_flutter_app/api/wildbird_migrations_api.dart';
import 'package:livetec_flutter_app/components/bullet_point.dart';
import 'package:livetec_flutter_app/components/calendar.dart';
import 'package:livetec_flutter_app/components/custom_info_window.dart';
import 'package:livetec_flutter_app/components/filters_container.dart';
import 'package:livetec_flutter_app/components/icon_button.dart';
import 'package:livetec_flutter_app/components/map.dart';
import 'package:livetec_flutter_app/components/map_type_button.dart';
import 'package:livetec_flutter_app/components/standard_container.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/constants/config.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';
import 'package:livetec_flutter_app/types/classification.dart';
import 'package:livetec_flutter_app/types/death.dart';
import 'package:livetec_flutter_app/types/farm.dart';
import 'package:livetec_flutter_app/types/map_element.dart';
import 'package:livetec_flutter_app/types/map_overlay.dart';
import 'package:livetec_flutter_app/types/migration.dart';
import 'package:livetec_flutter_app/types/outbreak.dart';
import 'package:livetec_flutter_app/types/risk.dart';
import 'package:livetec_flutter_app/utils/date_time.dart';
import 'package:livetec_flutter_app/utils/string.dart';

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

  bool _isLoading = true;
  Set<MapElement> _mapElementSet = {};
  final List<MapElementCategory> _hiddenCategories = [
    MapElementCategory.wildbirdMigrations,
    MapElementCategory.farms,
  ];

  Risk? _activeOutbreakRisk;
  String? _activeOutbreakZone;
  Risk? _historicalOutbreakRisk;
  String? _historicalOutbreakZone;
  String? _wildbirdDeathsSpecies;
  String? _wildbirdMigrationsSpecies;
  String? _farmCountry;
  String? _farmCounty;
  Classification? _farmClassification;
  bool? _farmOperating;

  int _currentPoultryOutbreaksCount = 0;
  int _currentCattleOutbreaksCount = 0;
  int _historicalOutbreaksCount = 0;
  int _wildbirdDeathsCount = 0;
  int _wildbirdMigrationsCount = 0;
  int _farmsCount = 0;

  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    super.initState();
    _getMapElementSet();
  }

  Future<void> _getMapElementSet() async {
    setState(() => _isLoading = true);

    Set<MapElement> newMapElementSet = {};
    final startOfToday = stripTime(DateTime.now());

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
          );
        }

        Marker marker = Marker(
          markerId: MarkerId(outbreak.id),
          position: outbreak.location,
          icon: BitmapDescriptor.defaultMarkerWithHue(hue),
          onTap: () => _customInfoWindowController.addInfoWindow!(
            CustomInfoWindowContainer(
              title:
                  '${outbreak.ended == null ? 'Active' : 'Historical'} ${outbreak.type} ${outbreak.disease} Outbreak',
              children: [
                'Start Date: ${outbreak.started}',
                (outbreak.ended == null ? null : 'End Date ${outbreak.ended}'),
                'Latitude: ${outbreak.location.latitude}',
                'Longitude: ${outbreak.location.longitude}',
                'ConfNumber: ${outbreak.title}',
                'Zone: ${outbreak.zone}',
                'Risk: ${outbreak.risk.value}',
              ],
            ),
            outbreak.location,
          ),
        );

        newMapElementSet.add(
          MapElement(
            category: category,
            minDate: outbreak.started,
            maxDate: outbreak.ended == null ? startOfToday : outbreak.ended!,
            firstMarker: marker,
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
            firstMarker: Marker(
              markerId: MarkerId(death.id),
              position: death.location,
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              onTap: () => _customInfoWindowController.addInfoWindow!(
                CustomInfoWindowContainer(
                  title:
                      '${death.numberOfBirdsAffected} ${death.species} Death${death.numberOfBirdsAffected == 1 ? '' : 's'} by ${death.virus}',
                  children: [
                    'Date: ${death.date}',
                    'Latitude: ${death.location.latitude}',
                    'Longitude: ${death.location.longitude}',
                    'Country: ${death.country}',
                    (death.county == null ? null : 'County: ${death.county}'),
                    'Locality: ${death.locality}',
                  ],
                ),
                death.location,
              ),
            ),
          ),
        );
      }
    }

    void addMigration(List<Migration> migrations, Color color, double hue) {
      for (Migration migration in migrations) {
        newMapElementSet.add(
          MapElement(
            category: MapElementCategory.wildbirdMigrations,
            minDate: migration.startDate,
            maxDate: migration.endDate,
            firstMarker: Marker(
              markerId: MarkerId(migration.id),
              position: migration.startLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              onTap: () => _customInfoWindowController.addInfoWindow!(
                CustomInfoWindowContainer(
                  title: '${migration.species} Migration Start',
                  children: [
                    'Date: ${migration.startDate}',
                    'Latitude: ${migration.startLocation.latitude}',
                    'Longitude: ${migration.startLocation.longitude}',
                  ],
                ),
                migration.startLocation,
              ),
            ),
            secondMarker: Marker(
              markerId: MarkerId(migration.id),
              position: migration.endLocation,
              icon: BitmapDescriptor.defaultMarkerWithHue(hue),
              onTap: () => _customInfoWindowController.addInfoWindow!(
                CustomInfoWindowContainer(
                  title: '${migration.species} Migration End',
                  children: [
                    'Date: ${migration.endDate}',
                    'Latitude: ${migration.endLocation.latitude}',
                    'Longitude: ${migration.endLocation.longitude}',
                  ],
                ),
                migration.endLocation,
              ),
            ),
            polyline: Polyline(
              polylineId: PolylineId(migration.id),
              points: [migration.startLocation, migration.endLocation],
              color: color,
              width: 2,
            ),
          ),
        );
      }
    }

    void addFarm(List<Farm> farms, Color color, double hue) {
      for (Farm farm in farms) {
        if (farm.longitude != null && farm.latitude != null) {
          newMapElementSet.add(
            MapElement(
              category: MapElementCategory.farms,
              minDate: calendarMinDate,
              maxDate: startOfToday,
              firstMarker: Marker(
                markerId: MarkerId(farm.id.toString()),
                position: LatLng(farm.latitude!, farm.longitude!),
                icon: BitmapDescriptor.defaultMarkerWithHue(hue),
                onTap: () => _customInfoWindowController.addInfoWindow!(
                  CustomInfoWindowContainer(
                    title: () {
                      final classifications = farm.classification
                          .map(
                            (classification) => seperateCamelCase(
                              classification.value,
                            ).split(' Farm')[0],
                          )
                          .toList();

                      if (classifications.isEmpty) return 'Farm';
                      if (classifications.length == 1) {
                        return '${classifications.first} Farm';
                      }

                      final allButLast = classifications
                          .sublist(0, classifications.length - 1)
                          .join(', ');
                      final last = classifications.last;
                      return '$allButLast and $last Farm';
                    }(),
                    children: [
                      'Latitude: ${farm.latitude}',
                      'Longitude: ${farm.longitude}',
                      'Country: ${farm.country == null ? '' : '${farm.country}'}',
                      'County: ${farm.county == null ? '' : '${farm.county}'}',
                      'Operating: ${farm.operating ? 'true' : 'false'}',
                    ],
                  ),
                  LatLng(farm.latitude!, farm.longitude!),
                ),
              ),
            ),
          );
        }
      }
    }

    List<Outbreak> activeOutbreaks = await getActiveOutbreaks(
      _dateRange.first,
      _dateRange.last,
      _activeOutbreakRisk,
      _activeOutbreakZone,
    );
    List<Outbreak> historicalOutbreaks = await getHistoricalOutbreaks(
      _dateRange.first,
      _dateRange.last,
      _historicalOutbreakRisk,
      _historicalOutbreakZone,
    );
    List<Death> wildbirdDeaths = await getWildbirdDeaths(
      _dateRange.first,
      _dateRange.last,
      _wildbirdDeathsSpecies,
    );
    List<Migration> wildbirdMigrations = await getWildbirdMigrations(
      _dateRange.first,
      _dateRange.last,
      _wildbirdMigrationsSpecies,
    );
    List<Farm> farms = await getFarms(
      _farmCountry,
      _farmCounty,
      _farmClassification,
      _farmOperating,
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

    addMigration(
      wildbirdMigrations,
      AppColors.azureBulletPoint,
      BitmapDescriptor.hueAzure,
    );

    // TODO: farms are not dependant on dates, unnecessary repeated call
    addFarm(farms, AppColors.greenBulletPoint, BitmapDescriptor.hueGreen);

    setState(() {
      _mapElementSet = newMapElementSet;
      _currentPoultryOutbreaksCount = poultryOutbreaks.length;
      _currentCattleOutbreaksCount = cattleOutbreaks.length;
      _historicalOutbreaksCount = historicalOutbreaks.length;
      _wildbirdDeathsCount = wildbirdDeaths.length;
      _wildbirdMigrationsCount = wildbirdMigrations.length;
      _farmsCount = farms.length;
    });
    _getMapOverlay();
  }

  void _getMapOverlay() {
    setState(() => _isLoading = true);

    MapOverlay newMapOverlay = MapOverlay();
    for (MapElement element in _mapElementSet) {
      if (!_hiddenCategories.contains(element.category) &&
          (_currentDate == null ||
              ((_currentDate!.isAtSameMomentAs(element.minDate) ||
                      _currentDate!.isAfter(element.minDate)) &&
                  (_currentDate!.isBefore(element.maxDate) ||
                      _currentDate!.isAtSameMomentAs(element.maxDate))))) {
        if (element.firstMarker != null) {
          newMapOverlay.markers.add(element.firstMarker!);
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
    setState(() {
      _mapOverlay = newMapOverlay;
      _isLoading = false;
    });
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

      _timer = Timer.periodic(timerDuration, (timer) {
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

      if (_dateRange.length == 1) {
        _dateRange[0] = _dateRange[0].subtract(const Duration(days: 1));
      } else if (_currentDate != null &&
          _currentDate!.isAfter(_dateRange.first)) {
        _currentDate = _currentDate!.subtract(const Duration(days: 1));
      }
    });
    _getMapOverlay();
  }

  void getNextDayInRangeSlider() {
    setState(() {
      _isDateRangePlaying = false;

      if (_dateRange.length == 1) {
        _dateRange[0] = _dateRange[0].add(const Duration(days: 1));
      } else if (_currentDate != null &&
          _currentDate!.isBefore(_dateRange.last)) {
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
      resizeToAvoidBottomInset: false,
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
            customInfoWindowController: _customInfoWindowController,
            mapType: _mapType,
            onTap: (LatLng position) => setState(() {
              _customInfoWindowController.hideInfoWindow!();
              _showFilters = false;
              _showMapLayers = false;
              _showCalendar = false;
            }),
            mapOverlay: _mapOverlay,
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 320,
            width: 320,
            offset: 50,
          ),

          AnimatedScale(
            alignment: Alignment(-0.9, -0.85),
            scale: _showFilters ? 1 : 0,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
            child: FiltersContainer(
              onApply:
                  (
                    Risk? activeOutbreakRisk,
                    String activeOutbreakZone,
                    Risk? historicalOutbreakRisk,
                    String historicalOutbreakZone,
                    String wildbirdDeathsSpecies,
                    String wildbirdMigrationsSpecies,
                    String farmCountry,
                    String farmCounty,
                    Classification? farmClassification,
                    bool? farmOperating,
                  ) {
                    setState(() {
                      _activeOutbreakRisk = activeOutbreakRisk;
                      _activeOutbreakZone = emptyAsNull(activeOutbreakZone);
                      _historicalOutbreakRisk = historicalOutbreakRisk;
                      _historicalOutbreakZone = emptyAsNull(
                        historicalOutbreakZone,
                      );
                      _wildbirdDeathsSpecies = emptyAsNull(
                        wildbirdDeathsSpecies,
                      );
                      _wildbirdMigrationsSpecies = emptyAsNull(
                        wildbirdDeathsSpecies,
                      );
                      _farmCountry = emptyAsNull(farmCountry);
                      _farmCounty = emptyAsNull(farmCounty);
                      _farmClassification = farmClassification;
                      _farmOperating = farmOperating;
                    });
                    _getMapElementSet();
                  },
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
                              spacing: 12,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text:
                                          'Current Poultry Outbreaks: $_currentPoultryOutbreaksCount',
                                      color: AppColors.orangeBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory
                                            .currentPoultryOutbreaks,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory
                                                  .currentPoultryOutbreaks,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory
                                                  .currentPoultryOutbreaks,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text:
                                          'Current Cattle Outbreaks: $_currentCattleOutbreaksCount',
                                      color: AppColors.blueBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory
                                            .currentCattleOutbreaks,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory
                                                  .currentCattleOutbreaks,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory
                                                  .currentCattleOutbreaks,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text:
                                          'Historical Outbreaks: $_historicalOutbreaksCount',
                                      color: AppColors.magentaBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory.historicalOutbreaks,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory
                                                  .historicalOutbreaks,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory
                                                  .historicalOutbreaks,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text:
                                          'Wildbird Deaths: $_wildbirdDeathsCount',
                                      color: AppColors.yellowBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory.wildbirdDeaths,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory.wildbirdDeaths,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory.wildbirdDeaths,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text:
                                          'Wildbird Migrations: $_wildbirdMigrationsCount',
                                      color: AppColors.azureBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory.wildbirdMigrations,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory
                                                  .wildbirdMigrations,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory
                                                  .wildbirdMigrations,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    BulletPoint(
                                      text: 'Farms: $_farmsCount',
                                      color: AppColors.greenBulletPoint,
                                    ),
                                    Checkbox(
                                      value: !_hiddenCategories.contains(
                                        MapElementCategory.farms,
                                      ),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true) {
                                            _hiddenCategories.remove(
                                              MapElementCategory.farms,
                                            );
                                          } else {
                                            _hiddenCategories.add(
                                              MapElementCategory.farms,
                                            );
                                          }
                                        });
                                        _getMapOverlay();
                                      },
                                    ),
                                  ],
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
                      _showCalendar = false;
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
                      _showCalendar = false;
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
                                if (_dateRange.length > 1) {
                                  if (!_isDateRangePlaying) {
                                    playRangeSlider();
                                  }

                                  setState(() {
                                    _isDateRangePlaying = !_isDateRangePlaying;
                                  });
                                }
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
                        onTap: () => setState(() {
                          _showCalendar = !_showCalendar;
                          _showFilters = false;
                          _showMapLayers = false;
                        }),
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

          if (_isLoading)
            Expanded(
              child: Container(
                color: AppColors.background.withValues(alpha: 0.2),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
