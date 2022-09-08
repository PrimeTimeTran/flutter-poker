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

  test('High card wins', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final players = [player1, player2];
    final round = Round(players);

    final cards = round.deck.cards;
    round.dealPlayerBySeat(0, cards[25]); // ad
    round.dealPlayerBySeat(0, cards[24]); // kd

    round.dealPlayerBySeat(1, cards[23]); // qd
    round.dealPlayerBySeat(1, cards[22]); // jd

    final board = <PlayingCard>[];

    board.add(cards[0]); // 2h
    board.add(cards[2]); // 4h
    board.add(cards[4]); // 6h
    board.add(cards[5]); // 8h
    board.add(cards[14]); // 3d

    print('hi');
    print(board);

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    // ([qd, jh, 9h, 8h, 7h, 6d, 5d], [kd, qh, qd, jh, 9h, 6d, 5d])
    expect(round.winner().seat, player1.seat);
  });

  test('Straight flush beats straight', () {
    final player1 = Player('Loi', 0);
    final player2 = Player('Bob', 1);
    final players = [player1, player2];
    final round = Round(players);

    final cards = round.deck.cards;
    round.dealPlayerBySeat(0, cards[24]); // kd
    round.dealPlayerBySeat(0, cards[23]); // qd

    round.dealPlayerBySeat(1, cards[6]); // 8h
    round.dealPlayerBySeat(1, cards[5]); // 9h

    final board = <PlayingCard>[];

    board.add(cards[9]); // jh
    board.add(cards[8]); // 10h
    board.add(cards[7]); // 9h
    board.add(cards[16]);
    board.add(cards[17]);

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    // ([jh, 10h, 9h, 8h, 7h, 6d, 5d], [kd, qd, jh, 10h, 9h, 6d, 5d])
    expect(round.winner().seat, player2.seat);
  });

  test('Straight flush beats flush', () {
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

    // ([ah, kh, 6h, 5h, 4h, 3h, 2h], [ah, kh, 6d, 5d, 4h, 3h, 2h])
    expect(round.winner().seat, player1.seat);
  });

  test('Higher straight flush beats lower straight flush', () {
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

    // ([kh, qh, jh, 10h, 9h, 6d, 5d], [jh, 10h, 9h, 8h, 7h, 6d, 5d])
    expect(round.winner().seat, player1.seat);
  });

  // test('A pair to defeat a highcard', () {});
}
