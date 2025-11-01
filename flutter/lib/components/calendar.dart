import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class Calendar extends StatelessWidget {
  final DateTime date;
  final void Function(List<DateTime>)? onValueChanged;

  const Calendar({super.key, required this.date, required this.onValueChanged});

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
                  style: isDisabled == true ? TextStyle(color: AppColors.neutral, fontWeight: FontWeight.w300) : TextStyle(color: AppColors.background, fontWeight: FontWeight.w600),
                ),
              ),
          selectedDayHighlightColor: AppColors.background,
          animateToDisplayedMonthDate: true,
          controlsTextStyle: const TextStyle(
            color: AppColors.background,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          disabledDayTextStyle: const TextStyle(color: AppColors.neutral),
          modePickersGap: 0,
          firstDate: DateTime(2010),
          lastDate: DateTime.now(),
        ),
        value: [date],
        onValueChanged: onValueChanged,
      ),
    );
  }
}
