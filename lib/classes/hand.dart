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
      highHand = cards.take(5).toList();
    }
    if (outcome == 'pair') {
      highHand = getPaired(cards);
    }
    if (outcome == 'two pair') {
      highHand = getTwoPaired(cards);
    }
    if (outcome == 'three of a kind') {
      highHand = getThreeOfAKind(cards);
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
    if (outcome == 'four of a kind') {
      highHand = getFourOfAKind(cards);
    }
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
