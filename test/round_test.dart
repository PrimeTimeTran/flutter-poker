import 'package:test/test.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';

void main() {
  test('2 hands in handsDealt if 2 players', () {
    final player1 = Player('Loi', 1);
    final player2 = Player('Bob', 0);
    final players = [player1, player2];
    final round = Round(players);
    round.dealPlayers();
    expect(round.handsDealt.length, 2);
  });

  test('3 hands in handsDealt if 2 players', () {
    final player1 = Player('Loi', 1);
    final player2 = Player('Bob', 0);
    final player3 = Player('John', 0);
    final players = [player1, player2, player3];
    final round = Round(players);
    round.dealPlayers();
    expect(round.handsDealt.length, 3);
  });

  test('2 player round to have 39 cards in deck after final action', () {
    final player1 = Player('Loi', 1);
    final player2 = Player('Bob', 0);
    final players = [player1, player2];
    final round = Round(players);
    round.deck.shuffle();
    round.dealPlayers();
    round.flop();
    round.turn();
    round.river();

    // 1 burn, 4 player
    // 1 burn, 3 flop
    // 1 burn, 1 turn
    // 1 burn, 1 river
    // 52 - 13 == 39

    expect(round.deck.remainingCards().length, 39);
  });
}
