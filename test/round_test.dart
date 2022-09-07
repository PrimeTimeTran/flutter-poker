import 'package:test/test.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

void main() {
  test('2 hands in handsDealt if 2 players', () {
    final player1 = Player('Loi', 1);
    final player2 = Player('Bob', 0);
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.entries.length, 2);
  });

  test('3 hands in handsDealt if 2 players', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final player3 = Player('John', 2);
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.entries.length, 3);
  });

  test('2 player round to have 39 cards in deck after final action', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);

    final players = [player1, player2];
    final round = Round(players);

    round.deck.shuffle();
    round.dealPlayers();

    round.flop();
    round.turn();
    round.river();

    expect(round.deck.remainingCards().length, 39);
  });

  test('Highest high card wins', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final players = [player1, player2];
    final round = Round(players);
    round.prepareHands(players.length);

    final cards = round.deck.cards;
    round.dealPlayerBySeat(0, cards[11]);
    round.dealPlayerBySeat(0, cards[8]);

    round.dealPlayerBySeat(1, cards[10]);
    round.dealPlayerBySeat(1, cards[9]);

    final board = <PlayingCard>[];

    board.add(cards[13]);
    board.add(cards[14]);
    board.add(cards[15]);
    board.add(cards[16]);
    board.add(cards[5]);

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner(), player1.seat);
  });
  // test('A pair to defeat a highcard', () {});
}
