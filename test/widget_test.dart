import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funguy/main.dart';

void main() {
  testWidgets('Guide search and notebook keep specimen navigation coherent', (
    tester,
  ) async {
    await tester.pumpWidget(const FunGuyApp());
    await tester.tap(find.text('Field guide'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Trametes');
    await tester.pumpAndSettle();
    expect(find.text('Turkey tail'), findsOneWidget);
    expect(find.text('Fly agaric'), findsNothing);
    await tester.tap(find.byTooltip('Bookmark species'));
    await tester.tap(find.text('Notebook'));
    await tester.pumpAndSettle();
    expect(find.text('Turkey tail'), findsOneWidget);
    await tester.tap(find.text('Turkey tail'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('not a verified SDMyco observation'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
