import 'package:flutter/widgets.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class AppTextStyles {
  static const TextStyle screenTitle = TextStyle(
    fontSize: 28,
    letterSpacing: 0.5,
    color: AppColors.primary,
  );
  static const TextStyle containerTitle = TextStyle(
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );
  static const TextStyle highlight = TextStyle(color: AppColors.primary);
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
  );
  static const TextStyle inverted = TextStyle(
    color: AppColors.background,
    fontWeight: FontWeight.w600,
  );
}
