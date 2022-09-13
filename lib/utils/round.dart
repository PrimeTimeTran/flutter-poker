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

getColHighValue(values) {
  return values.reduce((c, n) => c > n ? c : n);
}

getPlayerFromHighVal(values, players, i) {
  final highestValue = getColHighValue(values);

  for (var p in players) {
    if (p.hand.cardValues[i] == highestValue) {
      return p;
    }
  }
}

// Full house is tricky because the pair can come from either trips or pair.
// Here we have 2 trips in the player hand dealt + board
// [as, kc]
// [ah, ad, ac, kh, kh, 5h]
getFullHouseWinner(players, vals, matrix, i) {
  final highVal = getColHighValue(vals);
  players = players.where((p) => p.hand.cardValues[i] == highVal).toList();
  final matrix = getMatrix(players, 'full house');
  return getWinningPlayerFromType(players, matrix, 'full house');
}

getWinningPlayerFromType(players, matrix, type) {
  for (var i = 0; i < matrix.first.length; i++) {
    var values = setValuesFromColOfMatrix(matrix, i);
    if (values.length == 1) continue;

    if (type == 'full house') {
      if (values.length < matrix.length) {
        return getFullHouseWinner(players, values, matrix, i);
      }
      return getPlayerFromHighVal(values, players, i);
    } else {
      return getPlayerFromHighVal(values, players, i);
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

// A 2d matrix makes identifying highest card easier.
// We move left to right in each row until one column has a higher card
// than the other rows/hands in the same column
// [[12, 10, 5, 4, 2], [12, 11, 5, 4, 2], [12, 9, 5, 4, 2]]

const singleSlidingWindow = [
  'high card',
  'two pair',
  'straight',
  'flush',
  'straight flush'
];

const kindOfWindow = ['pair', 'trips', 'quads'];

getMatrix(players, type) {
  final matrix = List.generate(players.length, (_) => []);

  for (var i = 0; i < players.length; i++) {
    if (singleSlidingWindow.contains(type)) {
      setCardValues(players, matrix, i);
    } else if (kindOfWindow.contains(type)) {
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
