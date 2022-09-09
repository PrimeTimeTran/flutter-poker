import 'package:test/test.dart';
import 'package:flutpoke/classes/playing_card.dart';
import 'package:flutpoke/classes/hand.dart';

import 'package:flutpoke/utils/cards.dart';

void main() {
  // Test hands recognized
  test('Royal flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];
    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('qh'), card('jh'), card('10h'), card('2d'), card('3d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'royal flush');
  });

  test('Straight flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('kh'));
    hand.add(card('qh'));
    board.addAll([card('jh'), card('10h'), card('9h'), card('2d'), card('3d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight flush');
  });

  test('Four of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('kh'));
    hand.add(card('kd'));

    board.addAll([card('kc'), card('ks'), card('9h'), card('9d'), card('9s')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'four of a kind');
  });

  test('Full house to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('ac'), card('kd'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'full house');
  });

  test('Flush to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('jh'), card('10h'), card('9h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'flush');
  });

  test('Straights to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ad'));
    hand.add(card('kh'));

    board.addAll([card('qh'), card('jh'), card('10h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('Ace low straight to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('2h'));

    board.addAll([card('3d'), card('4d'), card('5d'), card('ac'), card('kc')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('Three of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('2h'));

    board.addAll([card('ad'), card('ac'), card('5d'), card('qc'), card('kc')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'three of a kind');
  });

  test('Two pairs to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('kd'), card('5c'), card('4c'), card('3c')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'two pair');
  });

  test('A pair to be recognized', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('6h'), card('5c'), card('4c'), card('3c')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'pair');
  });

  // Test played hands
  test(
      'Board cards to be highHand if outcome is high card and every board card is higher than dealt card',
      () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('2h'));
    hand.add(card('3h'));

    board.addAll([card('ad'), card('kd'), card('qd'), card('jd'), card('9c')]);

    hand.evaluateHand(board);

    List winningHand = [
      card('ad'),
      card('kd'),
      card('qd'),
      card('jd'),
      card('9c')
    ];

    expect(hand.highHand, winningHand);
  });

  test('Pair in high hand and 3 highest cards', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('ad'));

    board.addAll([card('5h'), card('kh'), card('2d'), card('3d'), card('7d')]);

    hand.evaluateHand(board);

    List winningHand = [
      card('ah'),
      card('ad'),
      card('kh'),
      card('7d'),
      card('5h'),
    ];

    expect(hand.highHand, winningHand);
  });

  test('Pair in high hand and 3 highest cards', () {
    final Hand hand = Hand(0);
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('ad'));

    board.addAll([card('kh'), card('7d'), card('5h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    List winningHand = [
      card('ah'),
      card('ad'),
      card('kh'),
      card('7d'),
      card('5h'),
    ];

    expect(hand.highHand, winningHand);
  });
}
