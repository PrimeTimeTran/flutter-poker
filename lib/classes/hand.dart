import 'dart:math';
import 'package:colorize/colorize.dart';
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

  rankMap() {
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

  high(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    print(cards);

    var outcome;

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
    // Colorize string = Colorize(outcome);
    // string.yellow();
    // print(string);
    return outcome;
  }

  paired() {
    final ranks = cards.map((c) => c.rank);
    var n = ranks.toSet().toList();
    return n.length == 6;
  }

  twoPaired() {
    final ranks = cards.map((c) => c.rank);
    var n = ranks.toSet().toList();
    return n.length == 5;
  }

  threeOfAKind() {
    final map = rankMap();
    return map.values.any((e) => e == 3);
  }

  straight() {
    final dp = [1, 1, 1, 1, 1, 1, 1];
    final ranks = cards.map((c) => c.value);
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
    return res > 4;
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

      final dp = [1, 1, 1, 1, 1, 1, 1];
      final ranks =
          cards.where((element) => element.suit == suit).map((c) => c.value);

      final nums = ranks.toSet().toList();

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
      return res > 4;
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
