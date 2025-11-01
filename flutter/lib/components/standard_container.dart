import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class StandardContainer extends StatelessWidget {
  final Widget child;

  const StandardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
