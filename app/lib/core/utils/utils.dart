import 'dart:ui';

String? validateField(String? value, {RegExp? regex, String? errMsg}) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  if (regex != null && !regex.hasMatch(value)) {
    return errMsg ?? 'Please enter a valid value';
  }
  return null;
}

List<DateTime> generateWeekDates(int weekOffset) {
  final today = DateTime.now();
  final startOfWeek = today
      .subtract(Duration(days: today.weekday - 1))
      .add(Duration(days: weekOffset * 7));
  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color) {
  final red = (color.r * 255.0).round().clamp(0, 255).toInt();
  final green = (color.g * 255.0).round().clamp(0, 255).toInt();
  final blue = (color.b * 255.0).round().clamp(0, 255).toInt();
  return '#${red.toRadixString(16).padLeft(2, '0')}${green.toRadixString(16).padLeft(2, '0')}${blue.toRadixString(16).padLeft(2, '0')}';
}

Color hexToRgb(String hex) {
  return Color(int.parse(hex.substring(1), radix: 16) + 0xFF000000);
}
