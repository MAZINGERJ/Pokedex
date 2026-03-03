import 'package:flutter_test/flutter_test.dart';

import 'package:pokedex/main.dart';

void main() {
  testWidgets('Pokedex app loads with splash', (WidgetTester tester) async {
    await tester.pumpWidget(const PokedexApp());
    expect(find.text('Pokédex'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pumpAndSettle();
  });
}
