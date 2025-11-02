import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class Calendar extends StatelessWidget {
  final List<DateTime> dates;
  final void Function(List<DateTime>) onValueChanged;

  const Calendar({
    super.key,
    required this.dates,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.dark(
          primary: AppColors.background,
          onPrimary: AppColors.primary,
        ),
      ),
      child: CalendarDatePicker2(
        config: CalendarDatePicker2Config(
          calendarType: CalendarDatePicker2Type.range,
          disableMonthPicker: true,
          dayBuilder:
              ({
                required date,
                textStyle,
                decoration,
                isSelected,
                isDisabled,
                isToday,
              }) => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected == true
                      ? Border.all(color: AppColors.background, width: 2)
                      : null,
                ),
                child: Text(
                  '${date.day}',
                  style: isDisabled == true
                      ? TextStyle(
                          color: AppColors.neutral,
                          fontWeight: FontWeight.w300,
                        )
                      : TextStyle(
                          color: AppColors.background,
                          fontWeight: FontWeight.w600,
                        ),
                ),
              ),
          selectedRangeHighlightBuilder:
              ({
                required DateTime dayToBuild,
                required bool isStartDate,
                required bool isEndDate,
              }) {
                if (isStartDate == true || isEndDate == true) {
                  return Row(
                    children: [
                      if (isStartDate) Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.symmetric(
                              horizontal: BorderSide(
                                color: AppColors.background,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (isEndDate) Expanded(flex: 1, child: Container()),
                    ],
                  );
                }

                return Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: AppColors.background,
                        width: 2,
                      ),
                    ),
                  ),
                );
              },
          selectedDayHighlightColor: AppColors.background,
          animateToDisplayedMonthDate: true,
          controlsTextStyle: const TextStyle(
            color: AppColors.background,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          disabledDayTextStyle: const TextStyle(color: AppColors.neutral),
          modePickersGap: 0,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        ),
        value: dates,
        onValueChanged: (List<DateTime> values) {
          // Hard limit to prevent backend overload
          if (values.last.isAfter(values.first.add(const Duration(days: 90)))) {
            values.remove(values.first);
          }

          onValueChanged(values);
        },
      ),
    );
  }
}
