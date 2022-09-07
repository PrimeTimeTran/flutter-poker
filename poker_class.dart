import 'package:colorize/colorize.dart';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Round {
  String step = 'ante';
  int blind = 100;
  List<PlayingCard> board = [];
  List players = [];
  List handsDealt = [];
  int buttonIdx = 0;
  Deck deck = Deck();

  dealPlayers() {
    final numOfHands = players.length;
    handsDealt = [Hand(), Hand()];
    deck.cards.removeAt(0);

    var handIdx = 0;

    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    handIdx = 0;

    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }
    step = 'pre-flop';

    return handsDealt;
  }

  flop() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    var card2 = deck.cards.removeAt(0);
    var card3 = deck.cards.removeAt(0);

    board = [card1, card2, card3];
    step = 'pre-turn';
    return board;
  }

  turn() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'pre-river';
    return board;
  }

  river() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'post-river';
    return board;
  }

  winner() {
    handsDealt[0].high(board);
  }

  dealFlush(deck) {
    final cards = deck.cards;
    final hand = Hand();
    hand.add(cards[12]);
    hand.add(cards[11]);
    handsDealt.add(hand);
    print(handsDealt);

    board.add(cards[10]);
    // board.add(cards[23]);
    board.add(cards[9]);
    board.add(cards[8]);
    board.add(cards[7]);
    board.add(cards[6]);
  }

  Round(this.players);
}

main() {
  final player1 = Player('Loi', 1);
  final player2 = Player('Bob', 0);
  final players = [player1];
  final round = Round(players);
  // round.deck.shuffle();
  // round.dealPlayers();
  // round.flop();
  // round.turn();
  // round.river();
  round.dealFlush(round.deck);
  round.winner();
}
