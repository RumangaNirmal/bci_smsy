import 'package:flutter_test/flutter_test.dart';

import 'package:bci_management_system/main.dart';

void main() {
  testWidgets('app launches with the dashboard screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BciManagementApp());

    expect(find.text('BCI Management System'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
  });
}
