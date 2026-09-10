String? validateField(String? value, {RegExp? regex, String? errMsg}) {
  if (value == null || value.trim().isEmpty) {
    return 'This field is required';
  }
  if (regex != null && !regex.hasMatch(value)) {
    return errMsg ?? 'Please enter a valid value';
  }
  return null;
}
