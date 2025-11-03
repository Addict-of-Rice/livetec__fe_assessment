String capitalizeFirstLetter(String value) {
  if (value.isEmpty) return value;
  return value[0].toUpperCase() + value.substring(1).toLowerCase();
}

String seperateCamelCase(String value) {
  return value
      .replaceAllMapped(
        RegExp(r'(?<!^)([A-Z])'),
        (Match match) => ' ${match.group(0)}',
      )
      .trim();
}

String? emptyAsNull(String? value) {
  if (value == '') {
    return null;
  }
  return value;
}
