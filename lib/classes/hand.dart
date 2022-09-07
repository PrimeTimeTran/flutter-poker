import 'dart:math';
import 'package:colorize/colorize.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Hand {
  List<PlayingCard> cards = [];

  add(card) {
    cards.add(card);
  }

  rankMap() {
    final ranks = cards.map((c) => c.rank);
    var map = Map();
    ranks.forEach((e) {
      if (!map.containsKey(e)) {
        map[e] = 1;
      } else {
        map[e] += 1;
      }
    });
    return map;
  }

  high(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));

    print(cards);

    var msg;

    if (straightFlush()) {
      msg = 'Straight Flush';
    } else if (fourOfAKind()) {
      msg = 'Four of a kind';
    } else if (fullHouse()) {
      msg = 'Full house';
    } else if (flush()) {
      msg = 'Flush';
    } else if (straight()) {
      msg = 'Straight';
    } else if (threeOfAKind()) {
      msg = 'Three of a kind!';
    } else if (twoPaired()) {
      msg = 'Two Pair';
    } else if (paired()) {
      msg = 'Pair';
    } else {
      msg = 'High Card';
    }
    Colorize string = new Colorize(msg);
    string.yellow();
    print(string);
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
    final map = Map();
    final suits = cards.map((c) => c.suit);
    suits.forEach((e) {
      if (!map.containsKey(e)) {
        map[e] = 1;
      } else {
        map[e] += 1;
      }
    });
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
    print(dp);
    final endingIdx = dp.indexOf(5);
    final straightCards = cards.sublist(endingIdx - 4, endingIdx + 1);
    final suit = straightCards[0].suit;
    final isStraightFlush =
        straightCards.map((e) => e.suit).every((s) => s == suit);
    return isStraightFlush;
  }
}
