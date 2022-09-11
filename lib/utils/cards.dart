import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutpoke/classes/deck.dart';

Map<String, int> handRankings = <String, int>{
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

getOfKind(cards, which) {
  int limit;
  if (which == 'two') {
    limit = 1;
  } else if (which == 'three') {
    limit = 2;
  } else {
    limit = 3;
  }

  return groupBy(cards, (dynamic c) => c.rank)
      .values
      .where((g) => g.length > limit)
      .toList();
}

getFourOfAKind(cards) {
  return getOfKind(cards, 'four').first;
}

getFullHouse(cards) {
  final map = rankMap(cards);

  var rank = map.keys.firstWhere((v) => map[v] == 3);

  final triplets = [];
  for (var card in cards) {
    if (card.rank == rank) {
      triplets.add(card);
    }
  }

  rank = map.keys.firstWhere((v) => map[v] == 2);

  final pair = [];
  for (var card in cards) {
    if (card.rank == rank) {
      pair.add(card);
    }
  }

  triplets.addAll(pair);

  return triplets;
}

getFlush(cards) {
  final map = suitMap(cards);
  final suit = map.keys.firstWhereOrNull((k) => map[k] > 4);
  if (suit == null) return false;
  var suitedCards = cards.where((element) => element.suit == suit);

  return suitedCards.take(5).toList();
}

getStraight(cards) {
  var seen = Set();
  List uniquelist = cards.where((c) => seen.add(c.value)).toList();

  var dp = [1, 1, 1, 1, 1, 1, 1];
  var ranks = uniquelist.map((c) => c.value);
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

  final endOfStraight = dp.indexOf(5);

  if (ranks.contains(12)) {
    uniquelist.add(cards.first);
  }

  return uniquelist.sublist(endOfStraight - 4, endOfStraight + 1);
}

getThreeOfAKind(cards) {
  var newCards = List.from(cards);
  var trips = getOfKind(cards, 'three').first;
  newCards.removeWhere((c) => c.rank == trips.first.rank);
  trips.addAll(newCards.take(2));
  return trips;
}

getTwoPaired(cards) {
  var newCards = List.from(cards);
  var firstPair = getOfKind(cards, 'two').first.toList();

  var secondPair = getOfKind(cards, 'two')[1].toList();

  newCards.removeWhere((c) => c.rank == firstPair.first.rank);
  newCards.removeWhere((c) => c.rank == secondPair.first.rank);

  firstPair.addAll(secondPair);
  firstPair.addAll(newCards.take(1));
  return firstPair;
}

getPaired(cards) {
  var newCards = List.from(cards);
  var pair = getOfKind(cards, 'two').first.toList();

  newCards.removeWhere((c) => c.rank == pair.first.rank);

  pair.addAll(newCards.take(3));

  return pair;
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
