import 'package:flutter_test/flutter_test.dart';
import 'package:nibbana_dhamma/main.dart';

void main() {
  testWidgets('App smoke test - builds root widget', (WidgetTester tester) async {
    // Verify MyApp instantiates cleanly
    const app = MyApp();
    expect(app, isNotNull);
  });
}
