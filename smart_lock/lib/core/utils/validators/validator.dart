class SValidator {
  static String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required.';
    }

    if (value.length != 4) {
      return 'PIN must be exactly 4 digits.';
    }

    if (!RegExp(r'^\d{4}$').hasMatch(value)) {
      return 'PIN must contain only numbers.';
    }

    return null;
  }

  static String? confirmFormerPin(String? firstValue, String? secondValue) {
    if (firstValue != secondValue) {
      return 'Pin does not match existing value';
    }
    return null;
  }

  static String? confirmPin(String? firstValue, String? secondValue) {
    if (firstValue != secondValue) {
      return 'Pin does not match';
    }
    return null;
  }

  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Field is required.';
    }
    return null;
  }
}
