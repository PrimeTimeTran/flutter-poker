import 'dart:async';
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
  var status = 'ante';
  var seatIdx = 0;
  var timer = null;

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
      status = 'preFlop';
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
    var timer = Timer(const Duration(seconds: 10), () => endRound());
  }

  endRound() {
    setState(() {
      round = Round(getPlayers());
      seatIdx = seatIdx + 1;
      status = status = 'ante';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PokerTable(
      flop: flop,
      turn: turn,
      river: river,
      round: round,
      status: status,
      dealCards: dealCards,
    );
  }
}
