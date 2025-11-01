import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';

class BulletPoint extends StatelessWidget {
  final String text;
  final Color color;

  const BulletPoint({super.key, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: HSLColor.fromColor(color)
                  .withLightness(
                    (HSLColor.fromColor(color).lightness * 0.6).clamp(0.0, 1.0),
                  )
                  .toColor(),
            ),
            color: color,
          ),
        ),
        Text(text, style: AppTextStyles.highlight),
      ],
    );
  }
}
