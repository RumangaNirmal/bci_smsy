import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fill = true,
    this.outlined = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fill;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Widget buttonContent = icon == null
        ? Text(label)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon),
              const SizedBox(width: 8),
              Text(label),
            ],
          );

    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: icon == null ? Text(label) : buttonContent,
      );
    }

    if (fill) {
      return FilledButton.icon(
        onPressed: onPressed,
        icon: icon == null ? const SizedBox.shrink() : Icon(icon),
        label: icon == null ? Text(label) : buttonContent,
      );
    }

    return TextButton.icon(
      onPressed: onPressed,
      icon: icon == null ? const SizedBox.shrink() : Icon(icon),
      label: icon == null ? Text(label) : buttonContent,
      style: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(AppColors.primary),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(label: label, onPressed: onPressed, icon: icon, fill: true);
  }
}

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return AppButton(label: label, onPressed: onPressed, icon: icon, outlined: true, fill: false);
  }
}
