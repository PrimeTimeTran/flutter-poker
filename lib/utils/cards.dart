import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutpoke/classes/deck.dart';

Map<String, int> handRankings = <String, int>{
  'royal flush': 10,
  'straight flush': 9,
  'quads': 8,
  'full house': 7,
  'flush': 6,
  'straight': 5,
  'trips': 4,
  'two pair': 3,
  'pair': 2,
  'high card': 1,
};

final deck = Deck();
final cards = deck.cards;

card(code) {
  return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
}

getFlushSuit(cards) {
  final map = suitMap(cards);
  return map.keys.firstWhereOrNull((k) => map[k] > 4);
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

getOfKind(which, cards) {
  int min = 3;
  if (which == 'trips') {
    min = 2;
  } else if (which == 'pair') {
    min = 1;
  }

  return groupBy(cards, (dynamic c) => c.rank)
      .values
      .where((g) => g.length > min)
      .toList();
}

getRoyalFlush(cards) {
  cards = getFlush(cards);
  return getStraight(cards, true);
}

getStraightFlush(cards) {
  cards = getFlush(cards);
  return getStraight(cards, true);
}

getFullHouse(cards) {
  final map = rankMap(cards);

  var rank = map.keys.firstWhere((v) => map[v] == 3);
  var list = map.values.toList();
  var twoTrips = list.where((e) => e == 3).length == 2;

  final triplets = [];
  for (var card in cards) {
    if (card.rank == rank) triplets.add(card);
  }

  var secondRank = map.keys.firstWhereOrNull((v) => map[v] == 2);
  secondRank ??= map.keys.where((v) => map[v] == 3).toList()[1];

  for (var card in cards) {
    if (card.rank == secondRank) triplets.add(card);
  }
  if (twoTrips) triplets.removeLast();

  return triplets;
}

getFlush(cards) {
  final suit = getFlushSuit(cards);
  if (suit == null) return false;
  var suitedCards = cards.where((element) => element.suit == suit);

  return suitedCards.take(5).toList();
}

getStraight(cards, getCards) {
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

  return getCards
      ? uniquelist.sublist(endOfStraight - 4, endOfStraight + 1)
      : res > 4;
}

getTwoPair(cards) {
  var pairs = getOfKind('pair', cards);
  var firstPair = pairs.first;
  var secondPair = pairs[1];

  cards.removeWhere((c) => c.rank == firstPair.first.rank);
  cards.removeWhere((c) => c.rank == secondPair.first.rank);

  firstPair.addAll(secondPair);
  firstPair.addAll(cards.take(1));
  return firstPair;
}

getKindOf(cards, kind) {
  int take = 1;
  if (kind == 'trips') {
    take = 2;
  } else if (kind == 'pair') {
    take = 3;
  }

  var permutation = getOfKind(kind, cards).first;

  cards.removeWhere((c) => c.rank == permutation.first.rank);
  permutation.addAll(cards.take(take));

  return permutation;
}
