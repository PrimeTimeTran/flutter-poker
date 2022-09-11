import 'package:test/test.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

import 'package:flutpoke/utils/cards.dart';
import 'package:flutpoke/utils/round.dart';

void main() {
  final player1 = Player('Ace', 0);
  final player2 = Player('Bill', 1);
  final player3 = Player('Cal', 2);

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

    board.addAll([card('10h'), card('9h'), card('7h'), card('6h'), card('5d')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner(), 'push');
  });

  test('Top pair wins', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kh'));
    round.dealPlayerBySeat(0, card('qh'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('jh'));

    round.dealPlayerBySeat(2, card('6d'));
    round.dealPlayerBySeat(2, card('8c'));

    board.addAll([card('ad'), card('kd'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();
    expect(round.winner().seat, player2.seat);
  });

  test('Top pair wins even with over high card', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ah'));
    round.dealPlayerBySeat(0, card('qh'));

    round.dealPlayerBySeat(1, card('qh'));
    round.dealPlayerBySeat(1, card('kh'));

    round.dealPlayerBySeat(2, card('6d'));
    round.dealPlayerBySeat(2, card('8c'));

    board.addAll([card('kd'), card('js'), card('4d'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();
    expect(round.winner().seat, player2.seat);
    expect(round.winner().hand.outcome, 'pair');
  });

  test('Top pair wins when its not highest cards', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kh'));
    round.dealPlayerBySeat(0, card('9d'));

    round.dealPlayerBySeat(1, card('jh'));
    round.dealPlayerBySeat(1, card('10h'));

    round.dealPlayerBySeat(2, card('2c'));
    round.dealPlayerBySeat(2, card('8c'));

    board.addAll([card('jd'), card('9d'), card('2h'), card('3h'), card('7c')]);

    round.dealCardsForTest(board);
    round.evaluateHands();
    expect(round.winner().seat, player2.seat);
  });

  test('Shared pair results in high card winning', () {
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

  test('Two pair beats one pair', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('2c'));
    round.dealPlayerBySeat(0, card('3c'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('qd'));

    round.dealPlayerBySeat(2, card('ks'));
    round.dealPlayerBySeat(2, card('3s'));

    board.addAll([card('kh'), card('qh'), card('2d'), card('4d'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest two pairs win', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('2c'));
    round.dealPlayerBySeat(0, card('3c'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('qd'));

    round.dealPlayerBySeat(2, card('ks'));
    round.dealPlayerBySeat(2, card('3s'));

    board.addAll([card('kh'), card('qh'), card('2d'), card('3d'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Same top pair higher lower pair wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kc'));
    round.dealPlayerBySeat(0, card('3c'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('qd'));

    round.dealPlayerBySeat(2, card('ks'));
    round.dealPlayerBySeat(2, card('3s'));

    board.addAll([card('kh'), card('qh'), card('2d'), card('3d'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Same two pairs with high card in player hand wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kc'));
    round.dealPlayerBySeat(0, card('qc'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('ad'));

    round.dealPlayerBySeat(2, card('ks'));
    round.dealPlayerBySeat(2, card('3s'));

    board
        .addAll([card('kh'), card('10h'), card('10d'), card('3d'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Same two pairs with high card on board pushes', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kc'));
    round.dealPlayerBySeat(0, card('qc'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('jd'));

    round.dealPlayerBySeat(2, card('ks'));
    round.dealPlayerBySeat(2, card('qs'));

    board
        .addAll([card('kh'), card('10h'), card('10d'), card('3d'), card('ah')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner(), 'push');
  });

  test('Three of a kind beats two pairs', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ac'));
    round.dealPlayerBySeat(0, card('kc'));

    round.dealPlayerBySeat(1, card('10s'));
    round.dealPlayerBySeat(1, card('10c'));

    round.dealPlayerBySeat(2, card('as'));
    round.dealPlayerBySeat(2, card('ks'));

    board.addAll([card('ah'), card('kh'), card('10h'), card('9d'), card('3d')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest three of a kind wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('qc'));
    round.dealPlayerBySeat(0, card('qh'));

    round.dealPlayerBySeat(1, card('ks'));
    round.dealPlayerBySeat(1, card('kh'));

    round.dealPlayerBySeat(2, card('4s'));
    round.dealPlayerBySeat(2, card('4c'));

    board.addAll([card('ah'), card('kc'), card('qd'), card('5s'), card('4d')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Same three of a kind delegates to high card', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kd'));
    round.dealPlayerBySeat(0, card('2c'));

    round.dealPlayerBySeat(1, card('ks'));
    round.dealPlayerBySeat(1, card('ac'));

    round.dealPlayerBySeat(2, card('qs'));
    round.dealPlayerBySeat(2, card('as'));

    board.addAll([card('kh'), card('kc'), card('10d'), card('3d'), card('4d')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Straight defeats three of a kind', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kd'));
    round.dealPlayerBySeat(0, card('ks'));

    round.dealPlayerBySeat(1, card('as'));
    round.dealPlayerBySeat(1, card('kc'));

    round.dealPlayerBySeat(2, card('6d'));
    round.dealPlayerBySeat(2, card('6c'));

    board.addAll([card('kh'), card('qs'), card('jd'), card('10d'), card('6h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest of three straights wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('9d'));
    round.dealPlayerBySeat(0, card('8d'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('kh'));

    round.dealPlayerBySeat(2, card('9c'));
    round.dealPlayerBySeat(2, card('8c'));

    board.addAll([card('qh'), card('jh'), card('10d'), card('2c'), card('3c')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Push if board straight plays', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('7c'));
    round.dealPlayerBySeat(0, card('6c'));

    round.dealPlayerBySeat(1, card('7d'));
    round.dealPlayerBySeat(1, card('6d'));

    round.dealPlayerBySeat(2, card('7s'));
    round.dealPlayerBySeat(2, card('6s'));

    board.addAll([card('qh'), card('jh'), card('10d'), card('9h'), card('8h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner(), 'push');
  });

  test('Ace low straight can win', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kd'));
    round.dealPlayerBySeat(0, card('2c'));

    round.dealPlayerBySeat(1, card('ac'));
    round.dealPlayerBySeat(1, card('kc'));

    round.dealPlayerBySeat(2, card('qs'));
    round.dealPlayerBySeat(2, card('5h'));

    board.addAll([card('2h'), card('3h'), card('4d'), card('5d'), card('kh')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Flush beats straight', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('as'));
    round.dealPlayerBySeat(0, card('6d'));

    round.dealPlayerBySeat(1, card('3h'));
    round.dealPlayerBySeat(1, card('2h'));

    round.dealPlayerBySeat(2, card('ac'));
    round.dealPlayerBySeat(2, card('5c'));

    board.addAll([card('kh'), card('qh'), card('jh'), card('10h'), card('5d')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Higher of two flushes wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('7d'));
    round.dealPlayerBySeat(0, card('6d'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('kh'));

    round.dealPlayerBySeat(2, card('qh'));
    round.dealPlayerBySeat(2, card('jh'));

    board.addAll([card('2h'), card('3h'), card('4d'), card('5d'), card('10h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest of three or more flushes wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('jh'));
    round.dealPlayerBySeat(0, card('10h'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('qh'));

    round.dealPlayerBySeat(2, card('6h'));
    round.dealPlayerBySeat(2, card('7h'));

    board.addAll([card('2h'), card('3h'), card('4d'), card('5d'), card('kh')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Board flush plays if higher than players', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ac'));
    round.dealPlayerBySeat(0, card('kc'));

    round.dealPlayerBySeat(1, card('as'));
    round.dealPlayerBySeat(1, card('2h'));

    round.dealPlayerBySeat(2, card('ad'));
    round.dealPlayerBySeat(2, card('kd'));

    board.addAll([card('8h'), card('3h'), card('4h'), card('6h'), card('7h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner(), 'push');
  });

  test('Board flush pushes', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('8h'));
    round.dealPlayerBySeat(0, card('7h'));

    round.dealPlayerBySeat(1, card('6h'));
    round.dealPlayerBySeat(1, card('5h'));

    round.dealPlayerBySeat(2, card('4h'));
    round.dealPlayerBySeat(2, card('3h'));

    board.addAll([card('ah'), card('kh'), card('qh'), card('jh'), card('9h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner(), 'push');
  });

  test('Full house beats flush', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('8h'));
    round.dealPlayerBySeat(0, card('7h'));

    round.dealPlayerBySeat(1, card('ad'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('4h'));
    round.dealPlayerBySeat(2, card('3h'));

    board.addAll([card('ah'), card('ac'), card('kh'), card('qh'), card('jh')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Full house higher trips wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kc'));
    round.dealPlayerBySeat(0, card('ks'));

    round.dealPlayerBySeat(1, card('ad'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('qc'));
    round.dealPlayerBySeat(2, card('qs'));

    board.addAll([card('ah'), card('ac'), card('kh'), card('qh'), card('jh')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Full house same trips delegates to pair', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('as'));
    round.dealPlayerBySeat(0, card('qc'));

    round.dealPlayerBySeat(1, card('ad'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('qd'));
    round.dealPlayerBySeat(2, card('qs'));

    board.addAll([card('ah'), card('ac'), card('kh'), card('qh'), card('jh')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Four of a kind beats full house', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ah'));
    round.dealPlayerBySeat(0, card('2h'));

    round.dealPlayerBySeat(1, card('kh'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('as'));
    round.dealPlayerBySeat(2, card('2s'));

    board.addAll([card('ah'), card('ac'), card('kc'), card('ks'), card('qd')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Highest four of a kind wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('kh'));
    round.dealPlayerBySeat(0, card('kd'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('as'));

    round.dealPlayerBySeat(2, card('qh'));
    round.dealPlayerBySeat(2, card('qd'));

    board.addAll([card('ah'), card('ac'), card('kc'), card('ks'), card('qc')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    printOutcome(round);

    expect(round.winner().seat, player2.seat);
  });

  test('Four of a kind on board delegates to high card', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('qh'));
    round.dealPlayerBySeat(0, card('qd'));

    round.dealPlayerBySeat(1, card('kh'));
    round.dealPlayerBySeat(1, card('kd'));

    round.dealPlayerBySeat(2, card('qc'));
    round.dealPlayerBySeat(2, card('qs'));

    board.addAll([card('ah'), card('ad'), card('ac'), card('as'), card('2h')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    printOutcome(round);

    expect(round.winner().seat, player2.seat);
  });

  test('Straight flush beats four of a kind', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('ah'));
    round.dealPlayerBySeat(0, card('ad'));

    round.dealPlayerBySeat(1, card('kh'));
    round.dealPlayerBySeat(1, card('qh'));

    round.dealPlayerBySeat(2, card('qc'));
    round.dealPlayerBySeat(2, card('qs'));

    board.addAll([card('jh'), card('10h'), card('9h'), card('ac'), card('as')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
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

  test('Higher straight flush beats lower straight flush', () {
    final board = <PlayingCard>[];
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('8d'));
    round.dealPlayerBySeat(0, card('7d'));

    round.dealPlayerBySeat(1, card('kd'));
    round.dealPlayerBySeat(1, card('qd'));

    board.addAll([card('jd'), card('10d'), card('9d'), card('2c'), card('2s')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    printOutcome(round);

    expect(round.winner().seat, player2.seat);
  });

  test('Highest straight flush', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('8h'));
    round.dealPlayerBySeat(0, card('7h'));

    round.dealPlayerBySeat(1, card('kh'));
    round.dealPlayerBySeat(1, card('qh'));

    round.dealPlayerBySeat(2, card('ah'));
    round.dealPlayerBySeat(2, card('ad'));

    board.addAll([card('jh'), card('10h'), card('9h'), card('ac'), card('as')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });

  test('Royal flush beats straight flush', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, card('9h'));
    round.dealPlayerBySeat(0, card('8h'));

    round.dealPlayerBySeat(1, card('ah'));
    round.dealPlayerBySeat(1, card('kh'));

    round.dealPlayerBySeat(2, card('9h'));
    round.dealPlayerBySeat(2, card('9d'));

    board.addAll([card('qh'), card('jh'), card('10h'), card('9c'), card('9s')]);

    round.dealCardsForTest(board);
    round.evaluateHands();

    expect(round.winner().seat, player2.seat);
  });
}
