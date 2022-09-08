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
    expect(round.players.length, 2);
  });

  test('3 hands in handsDealt if 2 players', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final player3 = Player('John', 2);
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.length, 3);
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

  test('Straight flush beats straight', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final players = [player1, player2];
    final round = Round(players);

    final cards = round.deck.cards;
    round.dealPlayerBySeat(0, cards[3]);
    round.dealPlayerBySeat(0, cards[4]);

    round.dealPlayerBySeat(1, cards[16]);
    round.dealPlayerBySeat(1, cards[17]);

    final board = <PlayingCard>[];

    board.add(cards[0]);
    board.add(cards[1]);
    board.add(cards[2]);
    board.add(cards[12]);
    board.add(cards[11]);

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  test('Higher straight flush wins', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final players = [player1, player2];
    final round = Round(players);

    final cards = round.deck.cards;
    round.dealPlayerBySeat(0, cards[11]);
    round.dealPlayerBySeat(0, cards[10]);

    round.dealPlayerBySeat(1, cards[6]);
    round.dealPlayerBySeat(1, cards[5]);

    final board = <PlayingCard>[];

    board.add(cards[9]);
    board.add(cards[8]);
    board.add(cards[7]);
    board.add(cards[16]);
    board.add(cards[17]);

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });
  // test('A pair to defeat a highcard', () {});
}
