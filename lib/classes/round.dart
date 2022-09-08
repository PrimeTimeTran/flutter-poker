import "dart:io";
import 'dart:collection';
import "package:collection/collection.dart";
import 'package:colorize/colorize.dart';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Round {
  int blind = 100;
  int buttonIdx = 0;
  Deck deck = Deck();
  String step = 'ante';
  List handsDealt = [];
  List<PlayingCard> board = [];
  Map players = <int, Map<dynamic, dynamic>>{};

  Round(List currentPlayers) {
    final playerMap = <int, Map>{};
    for (var player in currentPlayers) {
      playerMap[player.seat] = {'cards': []};
    }
    players = playerMap;
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
    final numOfHands = players.entries.length;

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
    for (var i = 0; i < handsDealt.length; i++) {
      players[i]['cards'] = handsDealt[i];
      players[i]['outcome'] = handsDealt[i].outcome;
      players[i]['ranking'] = handsDealt[i].ranking;
    }
  }

  dealCardsForTest(b) {
    board = b;
  }

  outcome() {
    final highs = handsDealt.map((h) => h.outcome).toList();
    Colorize string = new Colorize("-----------------");
    string.green();
    print(string);
    print(board);
    print(string);

    for (var i = 0; i < handsDealt.length; i++) {
      stdout.write(handsDealt[i]);
      print(': ' + highs[i] + '\n');
    }
  }

  winner() {
    final hands = collectHighestHands();
    final hand = identifyHighest(hands);

    // print('Hi Loi');
    // print(hand);
    // print('Hi Loi');
  }

  collectHighestHands() {
    final la = players.entries.map((e) => e).toList();
    print(la);
    final highestRanking = handsDealt[0].ranking;

    final hands = [];

    for (var hand in handsDealt) {
      if (hand.ranking == highestRanking) {
        hands.add(hand);
      }
    }

    return hands;
  }

  identifyHighest(hands) {
    if (hands.length == 1) {
      return hands[0];
    } else {
      // print(hands[0]);
    }
  }
}
