import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Deck {
  List<Card> cards = [];
  Deck() {
    var ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'J',
      'Q',
      'K',
      'A',
    ];
    var suits = ['c', 'd', 'h', 's'];

    for (var suit in suits) {
      ranks
          .asMap()
          .forEach((index, rank) => {cards.add(new Card(rank, suit, index))});
    }
  }

  getCards() {
    return cards;
  }

  toString() {
    return cards.toString();
  }

  shuffle() {
    cards.shuffle();
  }

  length() {
    return cards.length;
  }

  cardsWithSuit(String suit) {
    return cards.where((card) => card.suit == suit);
  }
}

class Card {
  String rank;
  String suit;
  int value;

  Card(this.rank, this.suit, this.value);

  toString() {
    return '$rank of $suit';
  }

}
