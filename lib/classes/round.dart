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
    players.firstWhere((p) => p.seat == seatIdx).hand.cards.add(card);
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

  updatePlayerHandAndBoard() {
    players.map((p) => p.hand.evaluateHand(board)).toList();
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
      if (outcome == 'straight-flush') {
        return players[0];
      }
      if (outcome == 'straight') {
        return players[0];
      }
      if (outcome == 'two-pair') {
        return players[0];
      }
      if (outcome == 'pair') {
        getPairValue(cards) {
          var dto = groupBy(cards, (dynamic c) => c.rank);
          var val = dto.values
              .where((g) => g.length > 1)
              .toList()
              .first
              .toList()
              .first
              .value;

          return val;
        }

        var winner = [getPairValue(players[0].hand.cards), players[0]];

        for (var p in players) {
          var val = getPairValue(p.hand.cards);
          if (val > winner.first) {
            winner = [val, p];
          }
        }
        return winner.last;
      }
      if (outcome == 'high-card') {
        final maxs = [];
        for (var p in players) {
          var maximum =
              p.hand.cards.reduce((a, b) => a.value > b.value ? a : b);
          maxs.add(maximum);
        }
        final card = maxs.reduce((a, b) => a.value > b.value ? a : b);
        return getPlayerWithCard(card);
      }
    }
  }

  getPlayerWithCard(c) {
    return players.firstWhere((p) => p.hand.cards.contains(c));
  }
}
