import 'package:colorize/colorize.dart';
import 'package:collection/collection.dart';

import 'package:flutpoke/utils/cards.dart';

printOutcome(round) {
  Colorize string = Colorize("\n------------------");
  string.green();
  print(string);

  print(round.board);
  print('\n');
  for (var player in round.players) {
    print(player.hand.outcome);
    print(player.hand.playerHand);
    print(player.hand.highHand);
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

getPlayerFromValues(values, players, i) {
  final highestValue = values.reduce((c, n) => c > n ? c : n);
  for (var p in players) {
    if (p.hand.cardValues[i] == highestValue) {
      return p;
    }
  }
}

getWinningPlayerFromType(players, matrix, handType) {
  for (var i = 0; i < matrix.first.length; i++) {
    final values = setValuesFromColOfMatrix(matrix, i);

    if (handType == 'pair' && values.length > 1) {
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'high hand' && values.length == matrix.length) {
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'trips' && values.length == matrix.length) {
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

setPairOrTripleValues(players, matrix, i, which) {
  final pairValue = getPairedOrTriples(players[i].hand.highHand, which)
      .first
      .toList()
      .first
      .value;
  final singleValues = getCardValues(players[i].hand.highHand);

  final rankings = [pairValue, ...singleValues];

  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

setHighCardValues(players, matrix, i) {
  final rankings = [];
  for (var j = 0; j < 5; j++) {
    rankings.add(players[i].hand.highHand[j].value);
  }
  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

setTwoPairValues(players, matrix, i) {
  final pairs = getPairedOrTriples(players[i].hand.highHand, 1);
  final firstPairValue = pairs.first.toList().first.value;
  final secondPairValue = pairs.last.toList().first.value;
  final singleValues = getCardValues(players[i].hand.highHand);

  final rankings = [firstPairValue, secondPairValue, ...singleValues];

  matrix[i].addAll(rankings);
  players[i].hand.cardValues = rankings;
}

getMatrix(players, which, type) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    if (type == 'high card') {
      setHighCardValues(players, matrix, i);
    } else if (type == 'pair' || type == 'triples') {
      setPairOrTripleValues(players, matrix, i, which);
    } else if (type == 'two pair') {
      setTwoPairValues(players, matrix, i);
    }
  }
  return matrix;
}

findBestThreeOfKindHand(players) {
  final matrix = getMatrix(players, 2, 'triples');

  final player = getWinningPlayerFromType(players, matrix, 'trips');
  if (player != null) {
    return player;
  }
}

findPlayerWithBestTwoPairHand(players) {
  final matrix = getMatrix(players, null, 'two pair');

  final player = getWinningPlayerFromType(players, matrix, 'pair');
  if (player != null) {
    return player;
  }
}

findPlayerWithBestPairHand(players) {
  // Flatten pairs
  // [[12, 5, 4, 2], [12, 11, 10, 5], [12, 5, 4, 2]]
  // [[7, 11, 9, 5], [9, 8, 7, 5], [0, 9, 7, 6]]
  final matrix = getMatrix(players, 1, 'pair');

  final player = getWinningPlayerFromType(players, matrix, 'pair');
  if (player != null) {
    return player;
  }

  // If here board played
  print('If here board played');
}

// A 2d matrix makes identifying highest card easier.
// We move left to right in each row until one column has a higher card
// than the other rows/hands in the same column

findPlayerWithBestHighCardHand(players) {
  // Create matrix from players and their hands
  // [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]
  final matrix = getMatrix(players, null, 'high card');

  final player = getWinningPlayerFromType(players, matrix, 'high hand');
  if (player != null) {
    return player;
  }

  // If here board played
  print('If here board played');
}
