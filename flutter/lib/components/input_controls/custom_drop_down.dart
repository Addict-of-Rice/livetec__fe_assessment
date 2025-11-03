import 'package:flutter/material.dart';
import 'package:livetec_flutter_app/components/input_controls/custom_input_decoration.dart';

class CustomDropdown<T> extends StatelessWidget {
  final String? labelText;
  final T? initialValue;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;

  const CustomDropdown({
    super.key,
    this.labelText,
    this.initialValue,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      initialValue: initialValue,
      decoration: customInputDecoration(
        labelText: labelText,
        alignLabelWithHint: false,
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}
