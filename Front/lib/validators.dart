class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  static String? validateEmailCode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Code received by email is required';
    }

    final codeRegExp = RegExp(r'^\d{6}$');
    if (!codeRegExp.hasMatch(value)) {
      return 'Invalid code format';
    }
    return null;
  }
}
