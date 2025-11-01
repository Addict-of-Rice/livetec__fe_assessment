import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(4),
      ),
      child: Icon(icon, size: 28, color: AppColors.neutral),
    );
  }
}
