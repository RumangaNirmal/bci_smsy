import 'package:flutter/material.dart';

import 'app_text_field.dart';

class SolidFormField extends StatelessWidget {
  const SolidFormField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.validator,
    this.hintText,
  });

  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      label: label,
      hintText: hintText,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
