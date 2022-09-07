import 'dart:collection';

import 'package:colorize/colorize.dart';
import "dart:io";

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
  }

  dealPlayerBySeat(seatIdx, card) {
    handsDealt[seatIdx].add(card);
  }

  prepareHands(numOfHands) {
    for (int i = 0; i < numOfHands; i++) {
      handsDealt.add(Hand(i));
    }
  }

  dealPlayers() {
    final numOfHands = players.entries.length;
    prepareHands(numOfHands);

    deck.cards.removeAt(0);
    var handIdx = 0;
    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      dealPlayerBySeat(handIdx, card);
      handIdx++;
    }

    handIdx = 0;
    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      dealPlayerBySeat(handIdx, card);
      handIdx++;
    }

    step = 'pre-flop';

    return handsDealt;
  }

  flop() {
    board = deck.flop();
    step = 'pre-turn';
  }

  turn() {
    board.add(deck.turn());
    step = 'pre-river';
  }

  river() {
    board.add(deck.river());
  }

  updatePlayerHandAndBoard() {
    handsDealt.map((h) => h.addHandAndBoard(board)).toList();
    for (var i = 0; i < handsDealt.length; i++) {
      players[i]['cards'] = handsDealt[i];
      players[i]['outcome'] = handsDealt[i].outcome;
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
    final highs = handsDealt.map((h) => h.outcome);
    var map = {};
    for (var high in highs) {
      if (!map.containsKey(high)) {
        map[high] = 1;
      } else {
        map[high] += 1;
      }
    }

    print('Winner func');
    print(players);
    print(board);
  }
}
