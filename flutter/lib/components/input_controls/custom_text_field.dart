import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livetec_flutter_app/components/input_controls/custom_input_decoration.dart';
import 'package:livetec_flutter_app/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int? minLines;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.minLines,
    this.keyboardType = TextInputType.multiline,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      minLines: minLines,
      maxLines: minLines != null ? null : 1,
      controller: controller,
      style: TextStyle(fontSize: 12),
      decoration: customInputDecoration(labelText: labelText)
    );
  }
}
