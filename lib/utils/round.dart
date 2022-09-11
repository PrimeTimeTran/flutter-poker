import 'package:colorize/colorize.dart';
import 'package:collection/collection.dart';

import 'package:flutpoke/utils/cards.dart';

printOutcome(round) {
  Colorize string = Colorize("\n------------------");
  string.green();

  print(string);
  print(string);
  print(round.board);
  print('\n');
  for (var player in round.players) {
    print(player.hand.outcome);
    print(player.hand.bestHand);
    print(player.hand.cardValues);
  }
  print(string);
  print('\n');
}

int sortDesc(a, b) => b.hand.ranking.compareTo(a.hand.ranking);

setValuesFromColOfMatrix(matrix, i) {
  final values = Set();
  for (var j = 0; j < matrix.length; j++) {
    values.add(matrix[j][i]);
  }

  return values;
}

getHighestCardValueInColumn(values) {
  return values.reduce((c, n) => c > n ? c : n);
}

getPlayerFromValues(values, players, i) {
  final highestValue = getHighestCardValueInColumn(values);

  for (var p in players) {
    if (p.hand.cardValues[i] == highestValue) {
      return p;
    }
  }
}

getWinningPlayerFromFullHouse(players, values, matrix, i) {
  final highestValue = getHighestCardValueInColumn(values);

  players = players.where((p) => p.hand.cardValues[i] == highestValue);

  var secondColumnValues = setValuesFromColOfMatrix(matrix, i + 1);
  secondColumnValues.remove(highestValue);

  final secondColumnHighestValue =
      getHighestCardValueInColumn(secondColumnValues);

  var play1PairVal = players.first.hand.cardValues[i + 1];
  var play2PairVal = players.last.hand.cardValues[i + 1];

  if (play1PairVal == play2PairVal) {
    return null;
  }

  final player = players
      .firstWhere((p) => p.hand.cardValues[i + 1] == secondColumnHighestValue);
  return player;
}

// Matrix will look different depending on how many players and which
// type of winning hand

getWinningPlayerFromType(players, matrix, handType) {
  for (var i = 0; i < matrix.first.length; i++) {
    var values = setValuesFromColOfMatrix(matrix, i);

    if (values.length == matrix.length &&
        (handType == 'high card' || handType == 'trips')) {
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'pair' && values.length > 1) {
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'straight' ||
        handType == 'flush' ||
        handType == 'straight flush') {
      if (values.length == 1) return null;
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'full house') {
      if (values.length == 1) return null;
      if (values.length < matrix.length) {
        return getWinningPlayerFromFullHouse(players, values, matrix, i);
      }
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'quads') {
      final highestValue = getHighestCardValueInColumn(values);
      if (players.every((p) => p.hand.cardValues[i] == highestValue)) {
        continue;
      }
      return getPlayerFromValues(values, players, i);
    }
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
  final trips = getOfKind('trips', hand);
  final pairs = getOfKind('pair', hand);

  final tripValue = trips.first.toList().first.value;
  final pairValue = pairs.last.toList().last.value;

  final rankings = [tripValue, pairValue];

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

// A 2d matrix makes identifying highest card easier.
// We move left to right in each row until one column has a higher card
// than the other rows/hands in the same column
// [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]

getMatrix(players, type) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    if (type == 'high card' ||
        type == 'two pair' ||
        type == 'straight' ||
        type == 'flush' ||
        type == 'straight flush') {
      setCardValues(players, matrix, i);
    } else if (type == 'pair' || type == 'trips' || type == 'quads') {
      setKindOfValues(players, matrix, i, type);
    } else if (type == 'full house') {
      setFullHouseValues(players, matrix, i);
    }
  }
  return matrix;
}

findPlayerWithBestTwoPairHand(players) {
  final matrix = getMatrix(players, 'two pair');

  final player = getWinningPlayerFromType(players, matrix, 'pair');
  if (player != null) {
    return player;
  }
  return 'push';
}

findBestHandFrom(players, type) {
  final matrix = getMatrix(players, type);

  final player = getWinningPlayerFromType(players, matrix, type);
  if (player != null) {
    return player;
  }
  return 'push';
}
