import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Deck {
  List<PlayingCard> cards = [];
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
      'j',
      'q',
      'k',
      'a',
    ];

    var suits = ['h', 'd', 'c', 's'];

    for (var suit in suits) {
      ranks.asMap().forEach((index, rank) => {
            cards.add(new PlayingCard(
                rank, suit, index, "assets/cards/$suit$rank.svg"))
          });
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

  deal(numOfHands) {
    debugPrint('Dealing');
    var handIdx = 0;
    List<List> handsDealt = [[], [], [], [], [], [], [], [], [], []];
    cards.removeAt(0);

    while (handIdx < numOfHands) {
      var card = cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    handIdx = 0;

    while (handIdx < numOfHands) {
      var card = cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    return handsDealt;
  }
}

class PlayingCard {
  String rank;
  String suit;
  int value;
  String path;

  PlayingCard(this.rank, this.suit, this.value, this.path);

  toString() {
    return '$suit$rank';
  }
}
