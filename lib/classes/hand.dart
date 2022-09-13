import 'package:flutpoke/utils/cards.dart';
import 'package:flutpoke/utils/hand.dart';

class Hand {
  int seatNumber;
  List cards = [];
  late int ranking;
  List bestHand = [];
  late String outcome;
  List playerHand = [];
  List? cardValues;

  Hand(this.seatNumber);

  add(card) {
    cards.add(card);
    playerHand.add(card);
  }

  toString() {
    return seatNumber.toString() +
        ': ' +
        playerHand.map((c) => '$c').join(', ');
  }

  evaluateHand(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    setOutcome();
    setHandRanking();
    setBestHand();
    return cards;
  }

  setOutcome() {
    outcome = getOutcome(cards);
  }

  setHandRanking() {
    ranking = handRankings[outcome] as int;
  }

  setBestHand() {
    bestHand = getHighCards(outcome, cards);
  }
}
