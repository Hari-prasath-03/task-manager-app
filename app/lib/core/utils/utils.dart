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
