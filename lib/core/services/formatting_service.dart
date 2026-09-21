class FormattingService {
  const FormattingService._();

  static String formatMoney(double value) => 'LKR ${value.toStringAsFixed(2)}';
}
