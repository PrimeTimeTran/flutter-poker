import 'dart:math';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Hand {
  List<PlayingCard> cards = [];
  List<PlayingCard> playerHand = [];

  add(card) {
    cards.add(card);
    playerHand.add(card);
  }

  toString() {
    return cards.map((c) => '$c').join(', ');
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

  high(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    var outcome;

    print(cards);

    if (royalFlush()) {
      outcome = 'royal-flush';
    } else if (straightFlush()) {
      outcome = 'straight-flush';
    } else if (fourOfAKind()) {
      outcome = 'four-of-a-kind';
    } else if (fullHouse()) {
      outcome = 'full-house';
    } else if (flush()) {
      outcome = 'flush';
    } else if (straight()) {
      outcome = 'straight';
    } else if (threeOfAKind()) {
      outcome = 'three-of-a-kind';
    } else if (twoPaired()) {
      outcome = 'two-pair';
    } else if (paired()) {
      outcome = 'pair';
    } else {
      outcome = 'high-card';
    }
    return outcome;
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
    if (flush()) {
      final map = suitMap();
      final suit = map.keys.firstWhere((k) => map[k] > 4);
      var cardz = cards.where((element) => element.suit == suit);
      return checkStraight(cardz);
    } else {
      return false;
    }
  }

  royalFlush() {
    final map = suitMap();
    final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
    if (suit == null) return false;
    final ranks = cards.where((element) => element.suit == suit).toList();
    return ranks[0].rank == 'a' && straightFlush();
  }
}
