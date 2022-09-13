import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

import 'package:flutpoke/utils/round.dart';
import 'package:flutpoke/utils/cards.dart';

class Round {
  int blind = 100;
  int buttonIdx = 0;
  late Deck deck;
  String step = 'ante';
  List<PlayingCard> board = [];
  List players = [];

  Round(currentPlayers) {
    deck = Deck();
    players = currentPlayers;
    prepareHands();
  }

  prepareHands() {
    for (var p in players) {
      p.hand = Hand();
    }
  }

  dealPlayerBySeat(seatNumber, card) {
    players.firstWhere((p) => p.seat == seatNumber).hand.add(card);
  }

  dealPlayers() {
    final numOfHands = players.length;
    deck.cards.shuffle();
    deck.cards.removeAt(0);

    for (var i = 0; i < 2; i++) {
      var handIdx = 0;
      while (handIdx < numOfHands) {
        var card = deck.cards.removeAt(0);
        dealPlayerBySeat(handIdx, card);
        handIdx++;
      }
    }
  }

  flop() {
    step = 'flopped';
    board = deck.flop();
  }

  turn() {
    step = 'turn';
    board.add(deck.turn());
  }

  river() {
    step = 'river';
    board.add(deck.river());
    evaluateHands();
    return winner();
  }

  evaluateHands() {
    players.map((p) => p.hand.evaluateHand(board)).toList();
  }

  dealCardsForTest(b) {
    board = b;
  }

  winner() {
    final players = getPlayersWithBestHands();
    return players.length == 1 ? players.first : identifyHighest(players);
  }

  getPlayersWithBestHands() {
    players.sort(sortDesc);
    List handValues = [];
    for (var p in players) {
      handValues.add(handRankings[p.hand.outcome]);
    }

    final highestRanking =
        handValues.reduce((curr, next) => curr > next ? curr : next);

    final bestPlayers = [];

    for (var p in players) {
      if (p.hand.ranking == highestRanking) {
        bestPlayers.add(p);
      }
    }

    return bestPlayers;
  }

  identifyHighest(players) {
    final outcome = players.first.hand.outcome;

    if (outcome == 'two pair') {
      return findPlayerWithBestTwoPairHand(players);
    }

    return findBestHandFrom(players, outcome);
  }
}
