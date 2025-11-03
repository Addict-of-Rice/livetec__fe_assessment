import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/components/standard_container.dart';
import 'package:livetec_flutter_app/constants/text_styles.dart';

class CustomInfoWindowContainer extends StatelessWidget {
  final String title;
  final List<String?> children;

  const CustomInfoWindowContainer({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return StandardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(title, style: AppTextStyles.containerTitle),
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: children.map((child) {
              return child != null
                  ? Text(child, style: AppTextStyles.highlight)
                  : const SizedBox.shrink();
            }).toList(),
          ),
        ],
      ),
    );
  }
}
