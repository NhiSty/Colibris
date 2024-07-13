import 'package:easy_localization/easy_localization.dart';

class Validators {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'email_required'.tr();
    }
    final emailRegExp = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'email_invalid'.tr();
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
