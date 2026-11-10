// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_hotelai/main.dart';

void main() {
  testWidgets('App starts', (WidgetTester tester) async {
    await tester.pumpWidget(const EasyStayApp());
    expect(find.text('EasyStay'), findsWidgets);
    expect(find.text('ค้นหา'), findsOneWidget);
  });

  testWidgets('Search results render on desktop', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1366, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const EasyStayApp());
    await tester.tap(find.text('ค้นหา'));
    await tester.pumpAndSettle();

    expect(find.text('ผลการค้นหา'), findsOneWidget);
    expect(find.text('RiverView Hotel'), findsOneWidget);
    await tester.tap(find.textContaining('ดูรายละเอียด').first);
    await tester.pumpAndSettle();
    expect(find.text('ประเภทห้องพัก'), findsOneWidget);

    final bookingButton = find.widgetWithText(FilledButton, 'จองห้องพัก').first;
    await tester.ensureVisible(bookingButton);
    await tester.tap(bookingButton);
    await tester.pumpAndSettle();
    expect(find.text('ข้อมูลการจอง'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
