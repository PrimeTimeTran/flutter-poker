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

setValuesFromColOfMatrix(matrix, i) {
  final values = Set();
  for (var j = 0; j < matrix.length; j++) {
    values.add(matrix[j][i]);
  }
  return values;
}

getPlayerFromValues(values, players, i) {
  final highestValue = values.reduce((c, n) => c > n ? c : n);
  for (var p in players) {
    if (p.hand.cardValues[i] == highestValue) {
      return p;
    }
  }
}

findPlayerWithHighestTwoPairs(players) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    var firstPairValue = getPairFromCards(players[i].hand.highHand).first.value;
    var secondPairValue = getPairFromCards(players[i].hand.highHand).last.value;
    var singleValues = groupBy(players[i].hand.highHand, (dynamic c) => c.rank)
        .values
        .where((g) => g.length == 1)
        .map((c) => c.first.value);

    final rankings = [firstPairValue, secondPairValue, ...singleValues];

    matrix[i].addAll(rankings);
    players[i].hand.cardValues = rankings;
  }

  for (var i = 0; i < matrix.first.length; i++) {
    final values = setValuesFromColOfMatrix(matrix, i);

    if (values.length > 1) {
      return getPlayerFromValues(values, players, i);
    }
  }
}

setPairValues(players, matrix, i) {
  var pairValue = getPairFromCards(players[i].hand.highHand).first.value;
  var singleValues = groupBy(players[i].hand.highHand, (dynamic c) => c.rank)
      .values
      .where((g) => g.length == 1)
      .map((c) => c.first.value);

  final rankings = [pairValue, ...singleValues];

  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

getWinningPlayerFromMatrix(players, matrix, condition) {
  for (var i = 0; i < matrix.first.length; i++) {
    final values = setValuesFromColOfMatrix(matrix, i);

    if (condition == 'values greater than' && values.length > 1) {
      return getPlayerFromValues(values, players, i);
    } else if (condition == 'values equal' && values.length == matrix.length) {
      return getPlayerFromValues(values, players, i);
    }
  }
}

getPairMatrix(players) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    setPairValues(players, matrix, i);
  }
  return matrix;
}

findPlayerWithHighestPairedHand(players) {
  // Flatten pairs
  // [[12, 5, 4, 2], [12, 11, 10, 5], [12, 5, 4, 2]]
  // [[7, 11, 9, 5], [9, 8, 7, 5], [0, 9, 7, 6]]
  final matrix = getPairMatrix(players);

  print(matrix);

  const condition = 'values greater than';

  final player = getWinningPlayerFromMatrix(players, matrix, condition);
  if (player != null) {
    return player;
  }

  // If here board played
  print('If here board played');
}

setHighCardValues(players, matrix, i) {
  final rankings = [];
  for (var j = 0; j < 5; j++) {
    rankings.add(players[i].hand.highHand[j].value);
  }
  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

getHighCardMatrix(players) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    setHighCardValues(players, matrix, i);
  }

  return matrix;
}

// A 2d matrix makes identifying highest card easier.
// We move left to right in each row until one column has a higher card
// than the other rows/hands in the same column

findPlayerWithHighestHighCardHand(players) {
  // Create matrix from players and their hands
  // [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]
  final matrix = getHighCardMatrix(players);

  const condition = 'values equal';

  final player = getWinningPlayerFromMatrix(players, matrix, condition);
  if (player != null) {
    return player;
  }

  // If here board played
  print('If here board played');
}
