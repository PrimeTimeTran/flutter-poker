import 'package:test/test.dart';
import 'package:flutpoke/classes/deck.dart';

void main() {
  test('Deck should have 52 cards', () {
    final deck = Deck();
    expect(deck.cards.length, 51);
  });
}
