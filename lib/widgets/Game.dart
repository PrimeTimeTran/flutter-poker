import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PokerTable.dart';

import 'package:flutpoke/classes/Round.dart';
import 'package:flutpoke/classes/Player.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Round round = Round(getPlayers());
  // preround, ante, preflop, flop, turn, river,
  var status = 'preflop';
  var seatIdx = 0;
  late List<List> cards = [
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  getPlayers() {
    var seats = [
      {'name': 'Ace', 'seat': 0},
      {'name': 'Bill', 'seat': 1},
      {'name': 'Cay', 'seat': 2},
      {'name': 'Dan', 'seat': 3},
      {'name': 'Ear', 'seat': 4},
      {'name': 'Kay', 'seat': 5},
      {'name': 'Loi', 'seat': 6},
      {'name': 'Tim', 'seat': 7},
      {'name': 'Jim', 'seat': 8},
      {'name': 'Who', 'seat': 9},
    ];

    final players = [];
    for (var player in seats) {
      players.add(Player(player['name'] as String, player['seat'] as int));
    }

    return players;
  }

  dealCards() {
    round.dealPlayers();
    setState(() {
      // cards = round.deck.deal(10);
      status = 'started';
      seatIdx = seatIdx + 1;
    });
  }

  flop() {
    round.flop();
    setState(() {
      status = round.step;
    });
  }

  turn() {
    round.turn();
    setState(() {
      status = round.step;
    });
  }

  river() {
    round.river();
    setState(() {
      status = round.step;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PokerTable(
      round: round,
      cards: cards,
      status: status,
      dealCards: dealCards,
      flop: flop,
      turn: turn,
      river: river,
    );
  }
}
