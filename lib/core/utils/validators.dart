String? emailValidator(String? value) => value == null || !value.contains('@')
    ? 'Enter a valid email address'
    : null;
String? passwordValidator(String? value) => value == null || value.length < 6
    ? 'Password must have at least 6 characters'
    : null;
String? requiredValidator(String? value, String label) =>
    value == null || value.trim().isEmpty ? '$label is required' : null;
String? mobileValidator(String? value) =>
    value == null || !RegExp(r'^\d{10}$').hasMatch(value)
    ? 'Enter a valid 10-digit mobile number'
    : null;
String? amountValidator(String? value) {
  final amount = double.tryParse(value ?? '');
  return amount == null || amount <= 0
      ? 'Enter an amount greater than zero'
      : null;
}
