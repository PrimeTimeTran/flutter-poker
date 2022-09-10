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
    print(player.hand.playerHand);
    print(player.hand.highHand);
  }
  print(string);
  print('\n');
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

getWinningPlayerFromType(players, matrix, handType) {
  for (var i = 0; i < matrix.first.length; i++) {
    final values = setValuesFromColOfMatrix(matrix, i);

    if (handType == 'pair' && values.length > 1) {
      return getPlayerFromValues(values, players, i);
    } else if (handType == 'high hand' && values.length == matrix.length) {
      return getPlayerFromValues(values, players, i);
    }
  }
}

findBestThreeOfKindHand(players) {
  print('getBestThreeOfAKind');
}

findPlayerWithBestTwoPairHand(players) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    final pairs = getPairFromCards(players[i].hand.highHand);
    final firstPairValue = pairs.first.toList().first.value;
    final secondPairValue = pairs.last.toList().first.value;
    final singleValues =
        groupBy(players[i].hand.highHand, (dynamic c) => c.rank)
            .values
            .where((g) => g.length == 1)
            .map((c) => c.first.value);

    final rankings = [firstPairValue, secondPairValue, ...singleValues];

    matrix[i].addAll(rankings);
    players[i].hand.cardValues = rankings;
  }

  final player = getWinningPlayerFromType(players, matrix, 'pair');
  if (player != null) {
    return player;
  }
}

setPairValues(players, matrix, i) {
  final hand = players[i].hand;
  final pairValue = getPairFromCards(hand.highHand).first.toList().first.value;
  final singleValues = groupBy(hand.highHand, (dynamic c) => c.rank)
      .values
      .where((g) => g.length == 1)
      .map((c) => c.first.value);

  final rankings = [pairValue, ...singleValues];

  matrix[i].addAll(rankings);
  hand.cardValues = rankings;
}

getPairMatrix(players) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    setPairValues(players, matrix, i);
  }
  return matrix;
}

findPlayerWithBestPairHand(players) {
  // Flatten pairs
  // [[12, 5, 4, 2], [12, 11, 10, 5], [12, 5, 4, 2]]
  // [[7, 11, 9, 5], [9, 8, 7, 5], [0, 9, 7, 6]]
  final matrix = getPairMatrix(players);

  final player = getWinningPlayerFromType(players, matrix, 'pair');
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

findPlayerWithBestHighCardHand(players) {
  // Create matrix from players and their hands
  // [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]
  final matrix = getHighCardMatrix(players);

  final player = getWinningPlayerFromType(players, matrix, 'high hand');
  if (player != null) {
    return player;
  }

  // If here board played
  print('If here board played');
}
