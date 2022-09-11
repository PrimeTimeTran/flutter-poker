import 'package:collection/collection.dart';

import 'package:flutpoke/utils/cards.dart';

class Hand {
  int seatIdx;
  List cards = [];
  late int ranking;
  List highHand = [];
  late String outcome;
  List playerHand = [];
  List? cardValues;

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
    setOutcome();
    setHandRanking();
    setPlayedCards();
    return cards;
  }

  setOutcome() {
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

  setHandRanking() {
    ranking = handRankings[outcome] as int;
  }

  setPlayedCards() {
    if (outcome == 'high card') {
      highHand = List.from(cards.take(5));
    }
    if (outcome == 'pair') {
      var newCards = List.from(cards);
      var pair = getOfKind(cards, 'two').first.toList();

      newCards.removeWhere((c) => c.rank == pair.first.rank);

      pair.addAll(List.from(newCards.take(3).toList()));

      highHand = pair;
    }
    if (outcome == 'two pair') {
      var newCards = List.from(cards);
      var firstPair = getOfKind(cards, 'two').first.toList();

      var secondPair = getOfKind(cards, 'two')[1].toList();

      newCards.removeWhere((c) => c.rank == firstPair.first.rank);
      newCards.removeWhere((c) => c.rank == secondPair.first.rank);

      firstPair.addAll(List.from(secondPair));
      firstPair.addAll(List.from(newCards.take(1).toList()));

      highHand = firstPair;
    }
    if (outcome == 'three of a kind') {
      var newCards = List.from(cards);
      var trips = getOfKind(cards, 'three').first.toList();
      newCards.removeWhere((c) => c.rank == trips.first.rank);
      trips.addAll(List.from(newCards.take(2).toList()));
      highHand = trips;
    }
    if (outcome == 'straight') {
      highHand = getStraight(cards);
    }

    if (outcome == 'flush') {
      highHand = getFlush(cards);
    }
    if (outcome == 'full house') {
      highHand = getFullHouse(cards);
    }
    if (outcome == 'four of a kind') {}
    if (outcome == 'straight flush') {}
    if (outcome == 'royal flush') {}
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
    final kards = cards.toSet().toList();
    return kards.first.suit == suit &&
        kards.first.rank == 'a' &&
        kards[4].suit == suit &&
        kards[4].rank == '10' &&
        straightFlush();
  }
}
