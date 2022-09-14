import 'package:collection/collection.dart';

import 'package:flutpoke/utils/cards.dart';

int sortDesc(a, b) => b.hand.ranking.compareTo(a.hand.ranking);

getValsFromCol(matrix, i) {
  final values = Set();
  for (var j = 0; j < matrix.length; j++) {
    values.add(matrix[j][i]);
  }

  return values;
}

getHighVal(values) {
  return values.reduce((c, n) => c > n ? c : n);
}

getPlayerFromHighVal(vals, players, i) {
  final highestValue = getHighVal(vals);

  for (var p in players) {
    if (p.hand.cardValues[i] == highestValue) {
      return p;
    }
  }
}

getFullHouseWinner(players, vals, matrix, i, type) {
  final highVal = getHighVal(vals);
  players = players.where((p) => p.hand.cardValues[i] == highVal).toList();
  final matrix = getMatrix(players, type);
  return getWinnerFromType(players, matrix, type);
}

getWinnerFromType(players, matrix, type) {
  for (var i = 0; i < matrix.first.length; i++) {
    var vals = getValsFromCol(matrix, i);
    if (vals.length == 1) continue;

    if (vals.length < matrix.length && type == 'full house') {
      return getFullHouseWinner(players, vals, matrix, i, type);
    }
    return getPlayerFromHighVal(vals, players, i);
  }
}

getCardValues(cards) {
  return groupBy(cards, (dynamic c) => c.rank)
      .values
      .where((g) => g.length == 1)
      .map((c) => c.first.value);
}

setMatrixAndValues(players, matrix, rankings, i) {
  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

setFullHouseValues(players, matrix, i) {
  final hand = players[i].hand.bestHand;
  final trips = getOfKind('trips', hand).first.toList().first.value;
  final pairs = getOfKind('pair', hand).last.toList().first.value;

  final rankings = [trips, pairs];

  setMatrixAndValues(players, matrix, rankings, i);
}

setKindOfValues(players, matrix, i, which) {
  final hand = players[i].hand.bestHand;
  final val = getOfKind(which, hand).first.toList().first.value;
  final remainingValues = getCardValues(hand);

  final rankings = [val, ...remainingValues];

  setMatrixAndValues(players, matrix, rankings, i);
}

setCardValues(players, matrix, i) {
  final rankings = [];
  for (var j = 0; j < 5; j++) {
    rankings.add(players[i].hand.bestHand[j].value);
  }
  setMatrixAndValues(players, matrix, rankings, i);
}

const twoSlide = ['pair', 'trips', 'quads'];

getMatrix(players, type) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    if (type == 'full house') {
      setFullHouseValues(players, matrix, i);
    } else if (twoSlide.contains(type)) {
      setKindOfValues(players, matrix, i, type);
    } else {
      setCardValues(players, matrix, i);
    }
  }
  return matrix;
}

// A 2d matrix makes identifying highest card easier.
// We move left to right in each row until one column has a higher card
// than the other rows/hands in the same column
// [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]

findBestHandFrom(players, type) {
  final matrix = getMatrix(players, type);

  final player = getWinnerFromType(players, matrix, type);
  if (player != null) {
    return player;
  }
  return 'push';
}
