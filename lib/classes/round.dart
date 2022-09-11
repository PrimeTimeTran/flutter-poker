import 'dart:math';
import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

import 'package:flutpoke/utils/round.dart';
import 'package:flutpoke/utils/cards.dart';

class Round {
  int blind = 100;
  int buttonIdx = 0;
  Deck deck = Deck();
  String step = 'ante';
  List<PlayingCard> board = [];
  List<Player> players = [];

  Round(List<Player> currentPlayers) {
    players = currentPlayers;
    prepareHands();
  }

  prepareHands() {
    for (var p in players) {
      p.hand = Hand(p.seat);
    }
  }

  dealPlayerBySeat(seatIdx, card) {
    players.firstWhere((p) => p.seat == seatIdx).hand.add(card);
  }

  dealPlayers() {
    final numOfHands = players.length;

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
    board = deck.flop();
  }

  turn() {
    board.add(deck.turn());
  }

  river() {
    board.add(deck.river());
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

    // why don't I work?
    // final highestRanking = handValues.max;
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
    if (outcome == 'royal flush') {
      return players.first;
    }
    if (outcome == 'straight flush') {
      return players.first;
    }
    if (outcome == 'four of a kind') {
      return players.first;
    }
    if (outcome == 'full house') {
      return findBestFullHouse(players);
    }
    if (outcome == 'flush') {
      return findBestFlushHand(players);
    }
    if (outcome == 'straight') {
      return findBestStraightHand(players);
    }
    if (outcome == 'three of a kind') {
      return findBestThreeOfKindHand(players);
    }
    if (outcome == 'two pair') {
      return findPlayerWithBestTwoPairHand(players);
    }
    if (outcome == 'pair') {
      return findPlayerWithBestPairHand(players);
    }
    if (outcome == 'high card') {
      return findPlayerWithBestHighCardHand(players);
    }
  }
}
