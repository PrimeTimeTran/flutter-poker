import 'package:flutpoke/classes/playing_card.dart';

class Deck {
  List<PlayingCard> cards = [];
  Deck() {
    final ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'j',
      'q',
      'k',
      'a',
    ];

    final suits = ['h', 'd', 'c', 's'];

    for (var suit in suits) {
      ranks.asMap().forEach((index, rank) => {
            cards.add(
                PlayingCard(rank, suit, index, "assets/cards/$suit$rank.svg"))
          });
    }
  }

  toString() {
    return cards.toString();
  }

  shuffle() {
    cards.shuffle();
    return cards;
  }

  cardsWithSuit(String suit) {
    return cards.where((card) => card.suit == suit);
  }

  getCards() {
    return cards;
  }

  remainingCards() {
    return cards;
  }

  flop() {
    cards.removeAt(0);
    var card1 = cards.removeAt(0);
    var card2 = cards.removeAt(0);
    var card3 = cards.removeAt(0);
    return [card1, card2, card3];
  }

  turn() {
    cards.removeAt(0);
    return cards.removeAt(0);
  }

  river() {
    cards.removeAt(0);
    return cards.removeAt(0);
  }
}
