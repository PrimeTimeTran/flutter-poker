import 'package:colorize/colorize.dart';
import "dart:io";

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

class Round {
  int blind = 100;
  List players = [];
  int buttonIdx = 0;
  Deck deck = Deck();
  String step = 'ante';
  List handsDealt = [];
  List<PlayingCard> board = [];

  Round(this.players);

  getHandsDealt() {
    return handsDealt;
  }

  dealPlayers() {
    final numOfHands = players.length;
    for (int i = 0; i < numOfHands; i++) {
      handsDealt.add(Hand(i));
    }

    deck.cards.removeAt(0);

    var handIdx = 0;
    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    handIdx = 0;
    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }
    step = 'pre-flop';

    return handsDealt;
  }

  flop() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    var card2 = deck.cards.removeAt(0);
    var card3 = deck.cards.removeAt(0);

    board = [card1, card2, card3];
    step = 'pre-turn';
    return board;
  }

  turn() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'pre-river';
    return board;
  }

  river() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'post-river';
    return board;
  }

  finalComparisons() {
    handsDealt.map((h) => h.addHandAndBoard(board)).toList();
  }

  outcome() {
    final highs = handsDealt.map((h) => h.high()).toList();
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
    final highs = handsDealt.map((h) => h.high());
    var map = {};
    for (var high in highs) {
      if (!map.containsKey(high)) {
        map[high] = 1;
      } else {
        map[high] += 1;
      }
    }

    print('Winner!');
    print(highs);
    print(map);
  }
}
