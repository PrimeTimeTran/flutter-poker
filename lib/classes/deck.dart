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
            cards.add(new PlayingCard(
                rank, suit, index, "assets/cards/$suit$rank.svg"))
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
}
