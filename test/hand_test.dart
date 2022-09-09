import 'package:test/test.dart';
import 'package:flutpoke/classes/playing_card.dart';
import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';

void main() {
  final deck = Deck();
  final cards = deck.cards;

  getCard(code) {
    return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
  }

  // Test hands recognized
  test('Royal flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];
    hand.add(getCard('ah'));
    hand.add(getCard('kh'));

    board.add(getCard('qh'));
    board.add(getCard('jh'));
    board.add(getCard('10h'));
    board.add(getCard('2d'));
    board.add(getCard('3d'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'royal-flush');
  });

  test('Straight flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('kh'));
    hand.add(getCard('qh'));

    board.add(getCard('jh'));
    board.add(getCard('10h'));
    board.add(getCard('9h'));
    board.add(getCard('2d'));
    board.add(getCard('3d'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight-flush');
  });

  test('Four of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('kh'));
    hand.add(getCard('kd'));

    board.add(getCard('kc'));
    board.add(getCard('ks'));
    board.add(getCard('9h'));
    board.add(getCard('9d'));
    board.add(getCard('9s'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'four-of-a-kind');
  });

  test('Full house to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('kh'));

    board.add(getCard('ad'));
    board.add(getCard('ac'));
    board.add(getCard('kd'));
    board.add(getCard('3d'));
    board.add(getCard('2d'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'full-house');
  });

  test('Flush to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('kh'));

    board.add(getCard('jh'));
    board.add(getCard('10h'));
    board.add(getCard('9h'));
    board.add(getCard('3d'));
    board.add(getCard('2d'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'flush');
  });

  test('Straights to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ad'));
    hand.add(getCard('kh'));

    board.add(getCard('qh'));
    board.add(getCard('jh'));
    board.add(getCard('10h'));
    board.add(getCard('3d'));
    board.add(getCard('2d'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('Ace low straight to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('2h'));

    board.add(getCard('3d'));
    board.add(getCard('4d'));
    board.add(getCard('5d'));
    board.add(getCard('ac'));
    board.add(getCard('kc'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'straight');
  });

  test('Three of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('2h'));

    board.add(getCard('ad'));
    board.add(getCard('ac'));
    board.add(getCard('5d'));
    board.add(getCard('qc'));
    board.add(getCard('kc'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'three-of-a-kind');
  });

  test('Two pairs to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('kh'));

    board.add(getCard('ad'));
    board.add(getCard('kd'));
    board.add(getCard('5c'));
    board.add(getCard('4c'));
    board.add(getCard('3c'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'two-pair');
  });

  test('A pair to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('kh'));

    board.add(getCard('ad'));
    board.add(getCard('6h'));
    board.add(getCard('5c'));
    board.add(getCard('4c'));
    board.add(getCard('3c'));

    hand.evaluateHand(board);

    expect(hand.outcome, 'pair');
  });

  // Test played hands
  test(
      'Board cards to be highHand if outcome is high card and every board card is higher than dealt card',
      () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('2h'));
    hand.add(getCard('3h'));

    board.add(getCard('ad'));
    board.add(getCard('kd'));
    board.add(getCard('qd'));
    board.add(getCard('jd'));
    board.add(getCard('9c'));

    hand.evaluateHand(board);

    List<PlayingCard> winningHand = [
      getCard('ad'),
      getCard('kd'),
      getCard('qd'),
      getCard('jd'),
      getCard('9c')
    ];

    expect(hand.highHand, winningHand);
  });

  test('Pair in high hand and 3 highest cards', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('ad'));

    board.add(getCard('5h'));
    board.add(getCard('kh'));
    board.add(getCard('2d'));
    board.add(getCard('3d'));
    board.add(getCard('7d'));
    hand.evaluateHand(board);

    List<PlayingCard> winningHand = [
      getCard('ah'),
      getCard('ad'),
      getCard('kh'),
      getCard('7d'),
      getCard('5h'),
    ];

    expect(hand.highHand, winningHand);
  });

  test('Pair in high hand and 3 highest cards', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(getCard('ah'));
    hand.add(getCard('ad'));

    board.add(getCard('kh'));
    board.add(getCard('7d'));
    board.add(getCard('5h'));
    board.add(getCard('3d'));
    board.add(getCard('2d'));
    hand.evaluateHand(board);

    List<PlayingCard> winningHand = [
      getCard('ah'),
      getCard('ad'),
      getCard('kh'),
      getCard('7d'),
      getCard('5h'),
    ];

    expect(hand.highHand, winningHand);
  });
}
