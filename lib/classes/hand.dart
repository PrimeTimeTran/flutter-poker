import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutpoke/classes/playing_card.dart';

import 'package:flutpoke/utils/cards.dart';

class Hand {
  int seatIdx;
  List cards = [];
  late int ranking;
  List highHand = [];
  late String outcome;
  List playerHand = [];

  Hand(this.seatIdx);

  add(card) {
    cards.add(card);
    playerHand.add(card);
  }

  toString() {
    return seatIdx.toString() + ': ' + playerHand.map((c) => '$c').join(', ');
  }

  evaluateHand(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    getOutcome();
    getHandRanking();
    setPlayedCards();
    return cards;
  }

  

  getOutcome() {
    String res;

    if (royalFlush()) {
      res = 'royal flush';
    } else if (straightFlush()) {
      res = 'straight flush';
    } else if (fourOfAKind()) {
      res = 'four of a kind';
    } else if (fullHouse()) {
      res = 'full house';
    } else if (flush()) {
      res = 'flush';
    } else if (straight()) {
      res = 'straight';
    } else if (threeOfAKind()) {
      res = 'three of a kind';
    } else if (twoPair()) {
      res = 'two pair';
    } else if (pair()) {
      res = 'pair';
    } else {
      res = 'high card';
    }
    outcome = res;
  }

  getHandRanking() {
    ranking = handRankings[outcome] as int;
  }

  setPlayedCards() {
    if (outcome == 'high card') {
      highHand = List.from(cards.take(5));
    }
    if (outcome == 'pair') {
      var newCards = List.from(cards);
      var pair = getPairFromCards(cards);

      newCards.removeWhere((c) => c.rank == pair.first.rank);

      pair.addAll(List<dynamic>.from(newCards.take(3).toList()));

      highHand = pair;
    }
  }

  pair() {
    final map = rankMap(cards);
    return map.values.any((e) => e == 2);
  }

  twoPair() {
    final map = rankMap(cards);
    return map.values.where((value) => value == 2).length > 1;
  }

  threeOfAKind() {
    final map = rankMap(cards);
    return map.values.any((e) => e == 3);
  }

  straight() {
    return checkStraight(cards);
  }

  flush() {
    final map = suitMap(cards);
    return map.values.any((e) => e > 4);
  }

  fullHouse() {
    final map = rankMap(cards);
    return map.values.any((e) => e == 3) && map.values.any((e) => e == 2);
  }

  fourOfAKind() {
    final map = rankMap(cards);
    return map.values.any((e) => e == 4);
  }

  straightFlush() {
    final map = suitMap(cards);
    final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
    if (suit == null) return false;
    final playingCards = cards.where((element) => element.suit == suit);
    return checkStraight(playingCards);
  }

  royalFlush() {
    final map = suitMap(cards);
    final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
    if (suit == null) return false;
    final ranks = cards.toSet().toList();
    return ranks[0].rank == 'a' && ranks[4].rank == '10' && straightFlush();
  }
}
