import 'package:flutpoke/utils/round.dart';
import 'package:test/test.dart';
import 'package:flutpoke/classes/playing_card.dart';
import 'package:flutpoke/classes/hand.dart';

import 'package:flutpoke/utils/cards.dart';

void main() {
  test('Royal flush to be recognized', () {
    final Hand hand = Hand();
    final List board = [];
    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('qh'), card('jh'), card('10h'), card('2d'), card('3d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'royal flush');
  });

  test('Straight flush to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('kh'));
    hand.add(card('qh'));
    board.addAll([card('jh'), card('10h'), card('9h'), card('2d'), card('3d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight flush');
  });

  test('quads be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('kh'));
    hand.add(card('kd'));

    board.addAll([card('kc'), card('ks'), card('9h'), card('9d'), card('9s')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'quads');
  });

  test('Full house to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('ac'), card('kd'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'full house');
  });

  test('Flush to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('jh'), card('10h'), card('9h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'flush');
  });

  test('Straight to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ad'));
    hand.add(card('kh'));

    board.addAll([card('qh'), card('jh'), card('10h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('Ace low straight to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('2h'));

    board.addAll([card('3d'), card('4d'), card('5d'), card('ac'), card('kc')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('trips be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('2h'));

    board.addAll([card('ad'), card('ac'), card('5d'), card('qc'), card('kc')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'trips');
  });

  test('Two pairs to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('kd'), card('5c'), card('4c'), card('3c')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'two pair');
  });

  test('A pair to be recognized', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('6h'), card('5c'), card('4c'), card('3c')]);

    hand.evaluateHand(board);

    expect(hand.outcome, 'pair');
  });

  // Test best hand
  test('Board cards be best hand if board cards higher than dealt hand', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('2h'));
    hand.add(card('3h'));

    board.addAll([card('ad'), card('kd'), card('qd'), card('jd'), card('9c')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ad'),
      card('kd'),
      card('qd'),
      card('jd'),
      card('9c')
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Two pairs to take highest possible high card', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('ad'));

    board.addAll([card('7d'), card('5h'), card('5d'), card('2d'), card('kh')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('ad'),
      card('5h'),
      card('5d'),
      card('kh'),
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Pair in best hand and 3 highest cards', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('ad'));

    board.addAll([card('kh'), card('7d'), card('5h'), card('3d'), card('2d')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('ad'),
      card('kh'),
      card('7d'),
      card('5h')
    ];

    expect(hand.bestHand, winningHand);
  });

  test('2 pairs to find best high card available even if in 3rd pair', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('2h'));
    hand.add(card('2d'));

    board
        .addAll([card('jh'), card('jd'), card('10h'), card('10d'), card('9h')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('jh'),
      card('jd'),
      card('10h'),
      card('10d'),
      card('9h')
    ];

    expect(hand.bestHand, winningHand);
  });

  test('2 pairs to find best high card available even if not in another pair',
      () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('2d'));

    board.addAll([
      card('2h'),
      card('jh'),
      card('jd'),
      card('10h'),
      card('10d'),
    ]);

    hand.evaluateHand(board);

    var winningHand = [
      card('jh'),
      card('jd'),
      card('10h'),
      card('10d'),
      card('ah')
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Straight to be the highest possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('3h'));
    hand.add(card('2h'));

    board.addAll([card('7d'), card('6d'), card('5h'), card('4h'), card('2d')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('7d'),
      card('6d'),
      card('5h'),
      card('4h'),
      card('3h')
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Flush to be highest possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('3h'));
    hand.add(card('2h'));

    board.addAll([card('ah'), card('kh'), card('qh'), card('jh'), card('2d')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('kh'),
      card('qh'),
      card('jh'),
      card('3h'),
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Full house to be highest trips possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('kh'));

    board.addAll([card('ad'), card('ac'), card('kd'), card('kc'), card('9h')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('ad'),
      card('ac'),
      card('kh'),
      card('kd'),
    ];

    expect(hand.bestHand, winningHand);
    expect(hand.outcome, 'full house');
  });

  test('Full house to be highest trips and pairs possible even if board', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('jh'));
    hand.add(card('jd'));

    board.addAll([card('ah'), card('ad'), card('ac'), card('kh'), card('kd')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('ad'),
      card('ac'),
      card('kh'),
      card('kd'),
    ];

    expect(hand.bestHand, winningHand);
    expect(hand.outcome, 'full house');
  });

  test('Straight flush to be highest possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('3h'));
    hand.add(card('2h'));

    board.addAll([card('ad'), card('7h'), card('6h'), card('5h'), card('4h')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('7h'),
      card('6h'),
      card('5h'),
      card('4h'),
      card('3h'),
    ];

    expect(hand.bestHand, winningHand);
  });

  test('Royal flush to be possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('ah'));
    hand.add(card('9h'));

    board.addAll([card('kh'), card('qh'), card('jh'), card('10h'), card('8h')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('kh'),
      card('qh'),
      card('jh'),
      card('10h'),
    ];

    expect(hand.bestHand, winningHand);
    expect(hand.outcome, 'royal flush');
  });

  test('Royal flush to contain highest cards possible', () {
    final Hand hand = Hand();
    final List board = [];

    hand.add(card('10h'));
    hand.add(card('8h'));

    board.addAll([card('ah'), card('kh'), card('qh'), card('jh'), card('9h')]);

    hand.evaluateHand(board);

    var winningHand = [
      card('ah'),
      card('kh'),
      card('qh'),
      card('jh'),
      card('10h'),
    ];

    expect(hand.bestHand, winningHand);
    expect(hand.outcome, 'royal flush');
  });
}
