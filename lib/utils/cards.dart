import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutpoke/classes/deck.dart';

Map handRankings = {
  'royal flush': 10,
  'straight flush': 9,
  'four of a kind': 8,
  'full house': 7,
  'flush': 6,
  'straight': 5,
  'three of a kind': 4,
  'two pair': 3,
  'pair': 2,
  'high card': 1,
};

final deck = Deck();
final cards = deck.cards;

card(code) {
  return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
}

Map rankMap(cards) {
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

Map suitMap(cards) {
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

getPairedOrTriples(cards, which) {
  return groupBy(cards, (dynamic c) => c.rank)
      .values
      .where((g) => g.length > which)
      .toList();
}

getFlush(cards) {
  final map = suitMap(cards);
  final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
  if (suit == null) return false;
  var suitedCards = List.from(cards.where((element) => element.suit == suit));

  return suitedCards.take(5).toList();
}

getStraight(cards) {
  var seen = Set();
  List uniquelist = cards.where((c) => seen.add(c.value)).toList();

  var dp = [1, 1, 1, 1, 1, 1, 1];
  var ranks = uniquelist.map((c) => c.value);
  var nums = ranks.toSet().toList();

  if (ranks.contains(11)) {
    nums.add(-1);
    dp.add(1);
  }

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

  final endOfStraight = dp.indexOf(5);

  if (ranks.contains(12)) {
    uniquelist.add(cards.first);
  }

  return uniquelist.sublist(endOfStraight - 4, endOfStraight + 1);
}

checkStraight(cards) {
  var dp = [1, 1, 1, 1, 1, 1, 1];
  var ranks = cards.map((c) => c.value);
  var nums = ranks.toSet().toList();

  if (ranks.contains(12)) {
    nums.add(-1);
    dp.add(1);
  }

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
