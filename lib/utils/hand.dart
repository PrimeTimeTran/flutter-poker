import 'package:flutpoke/utils/cards.dart';

getHighCards(outcome, cards) {
  var highHand;
  if (outcome == 'high card') {
    highHand = cards.take(5).toList();
  }
  if (outcome == 'pair') {
    highHand = getPaired(cards);
  }
  if (outcome == 'two pair') {
    highHand = getTwoPaired(cards);
  }
  if (outcome == 'three of a kind') {
    highHand = getThreeOfAKind(cards);
  }
  if (outcome == 'straight') {
    highHand = getStraight(cards, true);
  }
  if (outcome == 'flush') {
    highHand = getFlush(cards);
  }
  if (outcome == 'full house') {
    highHand = getFullHouse(cards);
  }
  if (outcome == 'four of a kind') {
    highHand = getFourOfAKind(cards);
  }
  if (outcome == 'straight flush') {
    highHand = getStraightFlush(cards);
  }
  if (outcome == 'royal flush') {
    highHand = getRoyalFlush(cards);
  }
  return highHand;
}

getOutcome(cards) {
  String res;

  if (royalFlush(cards)) {
    res = 'royal flush';
  } else if (straightFlush(cards)) {
    res = 'straight flush';
  } else if (fourOfAKind(cards)) {
    res = 'four of a kind';
  } else if (fullHouse(cards)) {
    res = 'full house';
  } else if (flush(cards)) {
    res = 'flush';
  } else if (straight(cards)) {
    res = 'straight';
  } else if (threeOfAKind(cards)) {
    res = 'three of a kind';
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

threeOfAKind(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 3);
}

straight(cards) {
  return checkStraight(cards);
}

flush(cards) {
  final map = suitMap(cards);
  return map.values.any((e) => e > 4);
}

fullHouse(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 3) && map.values.any((e) => e == 2);
}

fourOfAKind(cards) {
  final map = rankMap(cards);
  return map.values.any((e) => e == 4);
}

straightFlush(cards) {
  final suit = getFlushSuit(cards);
  if (suit == null) return false;
  final playingCards = cards.where((element) => element.suit == suit);
  return checkStraight(playingCards);
}

royalFlush(cards) {
  final suit = getFlushSuit(cards);
  if (suit == null) return false;
  final kards = cards.toSet().toList();
  return kards.first.suit == suit &&
      kards.first.rank == 'a' &&
      kards[4].suit == suit &&
      kards[4].rank == '10' &&
      straightFlush(cards);
}
