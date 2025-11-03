import 'package:flutter/material.dart';

InputDecoration customInputDecoration({
  String? labelText,
  bool alignLabelWithHint = true,
}) {
  return InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(8, 12, 8, 8),
        labelText: labelText,
        alignLabelWithHint: true,
        border: OutlineInputBorder(),
      );
}
