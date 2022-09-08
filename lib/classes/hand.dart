import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutpoke/classes/playing_card.dart';

final handRankings = <String, int>{
  'royal-flush': 10,
  'straight-flush': 9,
  'four-of-a-kind': 8,
  'full-house': 7,
  'flush': 6,
  'straight': 6,
  'three-of-a-kind': 5,
  'two-pair': 4,
  'pair': 3,
  'high-card': 2,
};

class Hand {
  int seatIdx;
  late String outcome;
  late int ranking;
  List<PlayingCard> cards = [];
  List<PlayingCard> playerHand = [];

  Hand(this.seatIdx);

  add(card) {
    cards.add(card);
    playerHand.add(card);
  }

  toString() {
    return seatIdx.toString() + ': ' + playerHand.map((c) => '$c').join(', ');
  }

  Map rankMap() {
    final ranks = cards.map((c) => c.rank);
    var map = {};
    for (var e in ranks) {
      if (!map.containsKey(e)) {
        map[e] = 1;
      } else {
        map[e] += 1;
      }
    }
    return map;
  }

  Map suitMap() {
    final map = {};
    final suits = cards.map((c) => c.suit);
    for (var e in suits) {
      if (!map.containsKey(e)) {
        map[e] = 1;
      } else {
        map[e] += 1;
      }
    }
    return map;
  }

  checkStraight(cardsToCheck) {
    var dp = [1, 1, 1, 1, 1, 1, 1];
    var ranks = cardsToCheck.map((c) => c.value);
    var nums = ranks.toSet().toList();
    for (var i = 0; i < nums.length; i++) {
      for (var j = 0; j < nums.length; j++) {
        if (nums[i] == nums[j] - 1) {
          dp[i] = max(dp[i], dp[j] + 1);
        }
      }
    }
    var res = 1;
    for (var i = 0; i < nums.length; i++) {
      if (res < dp[i]) {
        res = dp[i];
      }
    }
    if (res > 4) {
      return true;
    }
    return ranks.contains(12) &&
        ranks.contains(0) &&
        ranks.contains(1) &&
        ranks.contains(2) &&
        ranks.contains(3);
  }

  evaluateHand(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    getHandOutcome();
    getHandRaking();
  }

  getHandRaking() {
    ranking = handRankings[outcome] as int;
  }

  getHandOutcome() {
    String res;

    if (royalFlush()) {
      res = 'royal-flush';
    } else if (straightFlush()) {
      res = 'straight-flush';
    } else if (fourOfAKind()) {
      res = 'four-of-a-kind';
    } else if (fullHouse()) {
      res = 'full-house';
    } else if (flush()) {
      res = 'flush';
    } else if (straight()) {
      res = 'straight';
    } else if (threeOfAKind()) {
      res = 'three-of-a-kind';
    } else if (twoPaired()) {
      res = 'two-pair';
    } else if (paired()) {
      res = 'pair';
    } else {
      res = 'high-card';
    }
    outcome = res;
  }

  paired() {
    final map = rankMap();
    return map.values.any((e) => e == 2);
  }

  twoPaired() {
    final map = rankMap();
    return map.values.where((value) => value == 2).length > 1;
  }

  threeOfAKind() {
    final map = rankMap();
    return map.values.any((e) => e == 3);
  }

  straight() {
    return checkStraight(cards);
  }

  flush() {
    final map = suitMap();
    return map.values.any((e) => e > 4);
  }

  fullHouse() {
    final map = rankMap();
    return map.values.any((e) => e == 3) && map.values.any((e) => e == 2);
  }

  fourOfAKind() {
    final map = rankMap();
    return map.values.any((e) => e == 4);
  }

  straightFlush() {
    final map = suitMap();
    final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
    if (suit == null) return false;
    final playingCards = cards.where((element) => element.suit == suit);
    return checkStraight(playingCards);
  }

  royalFlush() {
    final map = suitMap();
    final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
    if (suit == null) return false;
    final ranks = cards.where((element) => element.suit == suit).toList();
    return ranks[0].rank == 'a' && straightFlush();
  }
}
