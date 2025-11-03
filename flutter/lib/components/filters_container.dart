import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/components/bullet_point.dart';
import 'package:livetec_flutter_app/components/input_controls/custom_drop_down.dart';
import 'package:livetec_flutter_app/components/input_controls/custom_text_field.dart';
import 'package:livetec_flutter_app/components/standard_container.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';
import 'package:livetec_flutter_app/types/classification.dart';
import 'package:livetec_flutter_app/types/risk.dart';
import 'package:livetec_flutter_app/utils/string.dart';

class FiltersContainer extends StatefulWidget {
  final Function(
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
  )
  onApply;

  const FiltersContainer({super.key, required this.onApply});

  @override
  State<FiltersContainer> createState() => _FiltersContainerState();
}

class _FiltersContainerState extends State<FiltersContainer> {
  final ScrollController _scrollController = ScrollController();
  Risk? _activeOutbreakRisk;
  final _activeOutbreakZoneController = TextEditingController();
  Risk? _historicalOutbreakRisk;
  final _historicalOutbreakZoneController = TextEditingController();
  final _wildbirdDeathsSpeciesController = TextEditingController();
  final _wildbirdMigrationsSpeciesController = TextEditingController();
  final _farmCountryController = TextEditingController();
  final _farmCountyController = TextEditingController();
  Classification? _farmClassification;
  bool? _farmOperating;

  @override
  Widget build(BuildContext context) {
    return StandardContainer(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Row(
              children: [
                SizedBox(width: 36),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      Text('Filters', style: AppTextStyles.containerTitle),
                      Divider(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          BulletPoint(
                            text: 'Current Outbreaks',
                            color: AppColors.orangeBulletPoint,
                          ),
                          CustomDropdown(
                            labelText: 'Risk',
                            items: [
                              DropdownMenuItem(value: null, child: Text('All')),
                              ...Risk.values.map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(seperateCamelCase(value.value)),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _activeOutbreakRisk = value),
                          ),
                          CustomTextField(
                            controller: _activeOutbreakZoneController,
                            labelText: 'Zone',
                          ),
                          SizedBox(height: 4),
                          BulletPoint(
                            text: 'Historical Outbreaks',
                            color: AppColors.magentaBulletPoint,
                          ),
                          CustomDropdown(
                            labelText: 'Risk',
                            items: [
                              DropdownMenuItem(value: null, child: Text('All')),
                              ...Risk.values.map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(seperateCamelCase(value.value)),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _historicalOutbreakRisk = value),
                          ),
                          CustomTextField(
                            controller: _historicalOutbreakZoneController,
                            labelText: 'Zone',
                          ),
                          SizedBox(height: 4),
                          BulletPoint(
                            text: 'Wildbird Deaths',
                            color: AppColors.yellowBulletPoint,
                          ),
                          CustomTextField(
                            labelText: 'Species',
                            controller: _wildbirdDeathsSpeciesController,
                          ),
                          SizedBox(height: 4),
                          BulletPoint(
                            text: 'Wildbird Migrations',
                            color: AppColors.azureBulletPoint,
                          ),
                          CustomTextField(
                            labelText: 'Species',
                            controller: _wildbirdMigrationsSpeciesController,
                          ),
                          SizedBox(height: 4),
                          BulletPoint(
                            text: 'Farms',
                            color: AppColors.greenBulletPoint,
                          ),
          
                          CustomTextField(
                            labelText: 'Country',
                            controller: _farmCountryController,
                          ),
                          CustomTextField(
                            labelText: 'County',
                            controller: _farmCountyController,
                          ),
                          CustomDropdown(
                            labelText: 'Classification',
                            items: [
                              DropdownMenuItem(value: null, child: Text('All')),
                              ...Classification.values.map(
                                (value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(seperateCamelCase(value.value)),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _farmClassification = value),
                          ),
                          CustomDropdown(
                            labelText: 'Operating',
                            items: [
                              DropdownMenuItem(value: null, child: Text('All')),
                              DropdownMenuItem(value: true, child: Text('True')),
                              DropdownMenuItem(
                                value: false,
                                child: Text('False'),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _farmOperating = value),
                          ),
                        ],
                      ),
                      Divider(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () => {
                            widget.onApply(
                              _activeOutbreakRisk,
                              _activeOutbreakZoneController.text,
                              _historicalOutbreakRisk,
                              _historicalOutbreakZoneController.text,
                              _wildbirdDeathsSpeciesController.text,
                              _wildbirdMigrationsSpeciesController.text,
                              _farmCountryController.text,
                              _farmCountyController.text,
                              _farmClassification,
                              _farmOperating,
                            ),
                          },
                          child: Text('Apply Filters'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
