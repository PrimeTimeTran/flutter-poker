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

  // // Test hands recognized
  test('Royal flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];
    hand.add(cards[12]);
    hand.add(cards[11]);

    board.add(cards[10]);
    board.add(cards[9]);
    board.add(cards[8]);
    board.add(cards[7]);
    board.add(cards[24]);
    // [ha, hk, dk, hq, hj, h10, h9]
    hand.evaluateHand(board);
    expect(hand.outcome, 'royal-flush');
  });

  test('Straight flushes to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[1]);
    hand.add(cards[11]);

    board.add(cards[10]);
    board.add(cards[9]);
    board.add(cards[8]);
    board.add(cards[7]);
    board.add(cards[24]);
    hand.evaluateHand(board);
    // [hk, dk, hq, hj, h10, h9, h3]
    expect(hand.outcome, 'straight-flush');
  });

  test('Four of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[0]);
    hand.add(cards[13]);

    board.add(cards[7]);
    board.add(cards[8]);
    board.add(cards[24]);
    board.add(cards[26]);
    board.add(cards[39]);
    hand.evaluateHand(board);
    // [dk, h10, h9, h2, d2, c2, s2]
    expect(hand.outcome, 'four-of-a-kind');
  });

  test('Full house to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[12]);
    hand.add(cards[25]);

    board.add(cards[1]);
    board.add(cards[2]);
    board.add(cards[7]);
    board.add(cards[14]);
    board.add(cards[27]);
    hand.evaluateHand(board);
    // [ha, da, h9, h4, h3, d3, c3]
    expect(hand.outcome, 'full-house');
  });

  test('Flush to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[12]);
    hand.add(cards[1]);

    board.add(cards[2]);
    board.add(cards[3]);
    board.add(cards[4]);
    board.add(cards[14]);
    board.add(cards[27]);
    hand.evaluateHand(board);
    // [ha, h6, h5, h4, h3, d3, c3]
    expect(hand.outcome, 'flush');
  });

  test('Straights to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[0]);
    hand.add(cards[14]);

    board.add(cards[2]);
    board.add(cards[3]);
    board.add(cards[4]);
    board.add(cards[33]);
    board.add(cards[27]);
    hand.evaluateHand(board);
    // [c9, h6, h5, h4, d3, c3, h2]
    expect(hand.outcome, 'straight');
  });

  test('Ace low straight to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[12]);
    hand.add(cards[13]);

    board.add(cards[14]);
    board.add(cards[15]);
    board.add(cards[16]);
    board.add(cards[33]);
    board.add(cards[27]);
    hand.evaluateHand(board);
    // [ah, 9c, 5d, 4d, 3d, 3c, 2d]
    expect(hand.outcome, 'straight');
  });

  test('Three of a kind be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[1]);
    hand.add(cards[13]);

    board.add(cards[7]);
    board.add(cards[8]);
    board.add(cards[24]);
    board.add(cards[26]);
    board.add(cards[39]);
    hand.evaluateHand(board);
    // [dk, h10, h9, h2, d2, c2, s2]
    expect(hand.outcome, 'three-of-a-kind');
  });

  test('Two pairs to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[0]);
    hand.add(cards[1]);

    board.add(cards[13]);
    board.add(cards[14]);
    board.add(cards[2]);
    board.add(cards[3]);
    board.add(cards[18]);
    hand.evaluateHand(board);
    // [sa, h6, h5, h3, d3, h2, d2]
    expect(hand.outcome, 'two-pair');
  });

  test('A pair to be recognized', () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[12]);
    hand.add(cards[25]);

    board.add(cards[3]);
    board.add(cards[11]);
    board.add(cards[13]);
    board.add(cards[14]);
    board.add(cards[18]);
    hand.evaluateHand(board);
    expect(hand.outcome, 'pair');
  });

  // Test played hands
  test(
      'Board cards to be highHand if outcome is high card and every board card is higher than dealt card',
      () {
    final Hand hand = Hand(0);
    final List<PlayingCard> board = [];

    hand.add(cards[0]);
    hand.add(cards[1]);

    board.add(cards[7]);
    board.add(cards[8]);
    board.add(cards[16]);
    board.add(cards[17]);
    board.add(cards[18]);
    hand.evaluateHand(board);

    List<PlayingCard> winningHand = [
      cards[8],
      cards[7],
      cards[18],
      cards[17],
      cards[16],
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
}
