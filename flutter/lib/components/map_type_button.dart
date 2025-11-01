import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:livetec_flutter_app/constants/colors.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';
import 'package:livetec_flutter_app/utils/string.dart';

class MapTypeButton extends StatelessWidget {
  final MapType selectedMapType;
  final MapType mapType;
  final String image;
  final VoidCallback onTap;

  const MapTypeButton({
    super.key,
    required this.selectedMapType,
    required this.mapType,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(
            color: selectedMapType == mapType
                ? AppColors.secondary
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 0.5,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 1,
          children: [
            CircleAvatar(radius: 16, backgroundImage: AssetImage(image)),
            Text(
              mapType.name == 'normal'
                  ? 'Default'
                  : capitalizeFirstLetter(mapType.name),
              style: AppTextStyles.label,
            ),
          ],
        ),
      ),
    );
  }
}
