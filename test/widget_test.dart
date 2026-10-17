import 'package:flutter_test/flutter_test.dart';
import 'package:trackink/main.dart';

void main() {
  testWidgets('boots TrackInk', (tester) async {
    await tester.pumpWidget(const TrackInkApp());

    expect(find.text('TrackInk'), findsOneWidget);
  });
}
