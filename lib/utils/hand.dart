import 'package:flutpoke/utils/cards.dart';

getHighCards(outcome, cards) {
  List bestHand;
  if (outcome == 'royal flush') {
    bestHand = getRoyalFlush(cards);
  } else if (outcome == 'straight flush') {
    bestHand = getStraightFlush(cards);
  } else if (outcome == 'full house') {
    bestHand = getFullHouse(cards);
  } else if (outcome == 'flush') {
    bestHand = getFlush(cards);
  } else if (outcome == 'straight') {
    bestHand = getStraight(cards, true);
  } else if (outcome == 'two pair') {
    bestHand = getTwoPair(cards);
  } else if (outcome == 'high card') {
    bestHand = cards.take(5).toList();
  } else {
    bestHand = getKindOf(cards, outcome);
  }
  return bestHand;
}

getOutcome(cards) {
  String res;

  if (royalFlush(cards)) {
    res = 'royal flush';
  } else if (straightFlush(cards)) {
    res = 'straight flush';
  } else if (quads(cards)) {
    res = 'quads';
  } else if (fullHouse(cards)) {
    res = 'full house';
  } else if (flush(cards)) {
    res = 'flush';
  } else if (straight(cards)) {
    res = 'straight';
  } else if (trips(cards)) {
    res = 'trips';
  } else if (twoPair(cards)) {
    res = 'two pair';
  } else if (pair(cards)) {
    res = 'pair';
  } else {
    res = 'high card';
  }
  return res;
}

pair(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 2);
}

twoPair(cards) {
  final map = rankMap(cards);
  return map.values.where((value) => value == 2).length > 1;
}

trips(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 3);
}

straight(cards) {
  return getStraight(cards, false);
}

flush(cards) {
  final map = suitMap(cards);
  return map.values.any((e) => e > 4);
}

fullHouse(cards) {
  final map = rankMap(cards);
  final oneTrips =
      map.values.any((e) => e == 3) && map.values.any((e) => e == 2);

  var twoTrips = false;
  if (!oneTrips) {
    var list = map.values.toList();
    twoTrips = list.where((e) => e == 3).length == 2;
  }

  return oneTrips || twoTrips;
}

quads(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 4);
}

straightFlush(cards) {
  final suit = getFlushSuit(cards);
  if (suit == null) return false;
  cards = cards.where((element) => element.suit == suit);
  return getStraight(cards, false);
}

royalFlush(cards) {
  final suit = getFlushSuit(cards);
  if (suit == null) return false;
  cards = cards.toSet().toList();
  return cards.first.suit == suit &&
      cards.first.rank == 'a' &&
      cards[4].suit == suit &&
      cards[4].rank == '10' &&
      getStraight(cards, false);
}
