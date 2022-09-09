import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutpoke/classes/deck.dart';

const handRankings = <String, int>{
  'royal flush': 10,
  'straight flush': 9,
  'four of a kind': 8,
  'full house': 7,
  'flush': 6,
  'straight': 6,
  'three of a kind': 5,
  'two pair': 4,
  'pair': 3,
  'high card': 2,
};

final deck = Deck();
final cards = deck.cards;

card(code) {
  return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
}

int sortDesc(a, b) => b.hand.ranking.compareTo(a.hand.ranking);

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

getPairFromCards(cards) {
  return groupBy(cards, (dynamic c) => c.rank)
      .values
      .where((g) => g.length > 1)
      .toList()
      .first
      .toList();
}

getPairValueFromCards(cards) {
  return getPairFromCards(cards).first.value;
}

getHighestRankedCard(cards) {
  return cards.reduce((a, b) => a.value > b.value ? a : b);
}

checkStraight(cards) {
  var dp = [1, 1, 1, 1, 1, 1, 1];
  var ranks = cards.map((c) => c.value);
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

  return res > 4;
}

getHighestCardsHand(players) {
  // Create 2d array
  // Iterate each rows col until we find a col that has a highest value
  // Return row that has that highest value
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    for (var j = 0; j < 5; j++) {
      matrix[i].add(players[i].hand.highHand[j].value);
    }
  }

  for (var i = 0; i < matrix[0].length; i++) {
    final values = Set();
    for (var j = 0; j < matrix.length; j++) {
      values.add(matrix[j][i]);
    }

    if (values.length == matrix.length) {
      var go = values.reduce((curr, next) => curr > next ? curr : next);
      for (var p in players) {
        if (p.hand.highHand[i].value == go) {
          return p;
        }
      }
    }
  }

  print('Pst here');
  // If here board played;
}
