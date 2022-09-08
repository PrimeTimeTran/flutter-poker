import "dart:io";
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
    final players = collectPlayersWithBestHands();
    final hand = identifyHighest(players);

    print(board);
    print(players[0].hand);
    print(players[1].hand);
    print(players[2].hand);
  }

  collectPlayersWithBestHands() {
    players.sort((a, b) => b.hand.ranking.compareTo(a.hand.ranking));

    final highestRanking = players[0].hand.ranking;

    final playersz = [];

    for (var p in players) {
      if (p.hand.ranking == highestRanking) {
        playersz.add(p);
      }
    }

    return playersz;
  }

  identifyHighest(players) {
    if (players.length == 1) {
      print('Single player');
      return players[0];
    } else {
      print('Multiple Players');
      // print(hands[0]);
    }
  }
}
