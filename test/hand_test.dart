import 'package:test/test.dart';
import 'package:flutpoke/classes/playing_card.dart';
import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';

void main() {
  final deck = Deck();
  final cards = deck.cards;
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
    // [c9, h6, h5, h4, d3, c3, h2]
    expect(hand.outcome, 'straight');
  });

  // TODO Straight with Ace

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

    hand.add(cards[12]); // ah
    hand.add(cards[25]); // ad

    board.add(cards[11]); // 4H
    board.add(cards[3]); // 5H
    board.add(cards[13]); // 2D
    board.add(cards[14]); // 3D
    board.add(cards[18]); // 7D
    hand.evaluateHand(board);
    // [ha, da, d7, h5, h4, d3, d2]
    expect(hand.outcome, 'pair');
  });
}
