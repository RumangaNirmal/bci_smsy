String? requiredValidator(String? value, {String? fieldName}) {
  final String trimmed = value?.trim() ?? '';
  if (trimmed.isEmpty) {
    return fieldName == null ? 'This field is required.' : '$fieldName is required.';
  }
  return null;
}

String? emailValidator(String? value) {
  final String? requiredMessage = requiredValidator(value, fieldName: 'Email');
  if (requiredMessage != null) {
    return requiredMessage;
  }

  final RegExp emailRegExp = RegExp(
    r'^[\w.!#$%&’*+/=?^`{|}~-]+@([\w-]+\.)+[\w-]{2,}$',
  );

  if (!emailRegExp.hasMatch(value!.trim())) {
    return 'Enter a valid email address.';
  }
  return null;
}

String? phoneValidator(String? value) {
  final String? requiredMessage = requiredValidator(value, fieldName: 'Phone number');
  if (requiredMessage != null) {
    return requiredMessage;
  }

  if (!RegExp(r'^[0-9+()\-\s]{7,20}$').hasMatch(value!.trim())) {
    return 'Enter a valid phone number.';
  }
  return null;
}

String? passwordValidator(String? value) {
  final String? requiredMessage = requiredValidator(value, fieldName: 'Password');
  if (requiredMessage != null) {
    return requiredMessage;
  }

  if (value!.trim().length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}
