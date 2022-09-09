import 'dart:math';
import 'dart:math';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/playing_card.dart';

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
    final players = getPlayersWithBestHands();
    final player = identifyHighest(players);
    return player;
  }

  getPlayersWithBestHands() {
    players.sort(sortDesc);
    final highestRanking = players.first.hand.ranking;

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
      return players.first;
    } else {
      final outcome = players.first.hand.outcome;
      if (outcome == 'royal flush') {
        return players.first;
      }
      if (outcome == 'straight flush') {
        return players.first;
      }
      if (outcome == 'straight') {
        return players.first;
      }
      if (outcome == 'two pair') {
        return players.first;
      }
      if (outcome == 'pair') {
        var winner = {
          'player': players.first,
          'score': getPairValueFromCards(players.first.hand.cards),
        };

        for (var p in players) {
          var val = getPairValueFromCards(p.hand.cards);
          if (val > winner['score']) {
            winner = {
              'score': val,
              'player': p,
            };
          }
        }
        return winner['player'];
      }

      if (outcome == 'high card') {
        return getHighestCardsHand(players);
      }
    }
  }
}
