import 'dart:math';

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

    if (fourOfAKind()) {
      print('Four of a kind!');
      msg = 'Four of a kind!';
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
    print(msg);
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

  fourOfAKind() {
    final map = rankMap();
    return map.values.any((e) => e == 4);
  }

  straight() {
    final map = rankMap();
    final dp = [1, 1, 1, 1, 1, 1, 1];
    final ranks = cards.map((c) => c.value);
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
    print('Straight logic $nums max straight is $res');
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
}
