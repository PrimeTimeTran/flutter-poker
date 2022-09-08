import "dart:io";
import 'dart:math';
import 'dart:collection';
import "package:collection/collection.dart";
import 'package:colorize/colorize.dart';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Round {
  int blind = 100;
  int buttonIdx = 0;
  Deck deck = Deck();
  String step = 'ante';
  List handsDealt = [];
  List<PlayingCard> board = [];
  List<Player> players = <Player>[];

  Round(List<Player> currentPlayers) {
    this.players = currentPlayers;
    prepareHands(players.length);
  }

  prepareHands(numOfHands) {
    for (int i = 0; i < numOfHands; i++) {
      handsDealt.add(Hand(i));
    }
  }

  dealPlayerBySeat(seatIdx, card) {
    handsDealt[seatIdx].add(card);
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

    return handsDealt;
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

  updatePlayerHandAndBoard() {
    handsDealt.map((h) => h.evaluateHand(board)).toList();
    handsDealt.forEachIndexed((i, h) => players[i].hand = h);
  }

  dealCardsForTest(b) {
    board = b;
  }

  winner() {
    final players = collectPlayersWithBestHands();
    final player = identifyHighest(players);
    return player;
  }

  collectPlayersWithBestHands() {
    players.sort((a, b) => b.hand.ranking.compareTo(a.hand.ranking));
    print(players.map((p) => p.hand.cards));
    final highestRanking = players[0].hand.ranking;

    final bestPlayers = [];

    for (var p in players) {
      if (p.hand.ranking == highestRanking) {
        bestPlayers.add(p);
      }
    }

    return bestPlayers;
  }

  identifyHighest(players) {
    if (players.length == 1) {
      return players[0];
    } else {
      final outcome = players[0].hand.outcome;
      print(outcome);
      final highestCard = [];
      if (outcome == 'straight-flush') {
        return players[0];
      }
      if (outcome == 'straight') {
        return players[0];
      }
      if (outcome == 'high-card') {
        return players[0];
      }
    }
  }
}
