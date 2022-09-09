import 'package:test/test.dart';
import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

void main() {
  final deck = Deck();
  final cards = deck.cards;

  final player1 = Player('Loi', 0);
  final player2 = Player('Bob', 1);
  final player3 = Player('John', 2);

  card(code) {
    return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
  }

  test('2 players if begun with 2 players', () {
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.length, 2);
  });

  test('3 players if begun with 3 players', () {
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.length, 3);
  });

  test('2 player round to have 39 cards in deck after final action', () {
    final players = [player1, player2];
    final round = Round(players);

    round.deck.shuffle();
    round.dealPlayers();

    round.flop();
    round.turn();
    round.river();

    expect(round.deck.remainingCards().length, 39);
  });

  test('Straight flush beats four of a kind', () {
    final board = <PlayingCard>[];
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kd'));
    round.dealPlayerBySeat(0, card('qd'));

    round.dealPlayerBySeat(1, card('2h'));
    round.dealPlayerBySeat(1, card('2d'));

    board.addAll([card('jd'), card('10d'), card('9d'), card('2c'), card('2s')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player1.seat);
  });

  test('Royal flush beats straight flush', () {
    final board = <PlayingCard>[];
    final players = [player2, player1];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ad'));
    round.dealPlayerBySeat(0, card('kd'));

    round.dealPlayerBySeat(1, card('9d'));
    round.dealPlayerBySeat(1, card('8d'));

    board.addAll([card('qd'), card('jd'), card('10d'), card('2c'), card('2s')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player1.seat);
  });

  // TODO order matters
  test('Higher straight flush beats lower straight flush', () {
    final board = <PlayingCard>[];
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kd'));
    round.dealPlayerBySeat(0, card('qd'));

    round.dealPlayerBySeat(1, card('8d'));
    round.dealPlayerBySeat(1, card('7d'));

    board.addAll([card('jd'), card('10d'), card('9d'), card('2c'), card('2s')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player1.seat);
  });

  test('High card wins', () {
    final board = <PlayingCard>[];
    final players = [player2, player1];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ad'));
    round.dealPlayerBySeat(0, card('kd'));

    round.dealPlayerBySeat(1, card('qd'));
    round.dealPlayerBySeat(1, card('jd'));

    board.addAll([card('2h'), card('3h'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player1.seat);
  });

  test('Highest cards wins', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('as'));
    round.dealPlayerBySeat(0, card('qd'));

    round.dealPlayerBySeat(1, card('ad'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('ac'));
    round.dealPlayerBySeat(2, card('jd'));

    board.addAll([card('2h'), card('3h'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest cards board plays draws', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('2c'));
    round.dealPlayerBySeat(0, card('3c'));

    round.dealPlayerBySeat(1, card('2s'));
    round.dealPlayerBySeat(1, card('3s'));

    round.dealPlayerBySeat(2, card('2d'));
    round.dealPlayerBySeat(2, card('3d'));

    board.addAll([card('9h'), card('10h'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    // TODO board played
    // expect(round.winner().seat, player2.seat);
  });

  test('Top pair wins', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ah'));
    round.dealPlayerBySeat(0, card('jh'));

    round.dealPlayerBySeat(1, card('kh'));
    round.dealPlayerBySeat(1, card('qh'));

    round.dealPlayerBySeat(2, card('6d'));
    round.dealPlayerBySeat(2, card('8c'));

    board.addAll([card('ad'), card('kd'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player1.seat);
  });

  // TODO Same top pair high card
  test('Shared pair with high card wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('2c'));
    round.dealPlayerBySeat(0, card('3c'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('qd'));

    round.dealPlayerBySeat(2, card('2s'));
    round.dealPlayerBySeat(2, card('3s'));

    board.addAll([card('ad'), card('ah'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });
}
