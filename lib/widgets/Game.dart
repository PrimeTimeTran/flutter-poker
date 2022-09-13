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
  var seatIdx = 0;
  var timer = null;
  var history = [];
  var status = 'ante';
  var winningPlayer = null;
  late Round round = Round(getPlayers());

  getPlayers() {
    var seats = [
      {'name': 'Alpha', 'seat': 0},
      {'name': 'Bravo', 'seat': 1},
      {'name': 'Charlie', 'seat': 2},
      {'name': 'Delta', 'seat': 3},
      {'name': 'Echo', 'seat': 4},
      {'name': 'Foxtrot', 'seat': 5},
      {'name': 'Golf', 'seat': 6},
      {'name': 'Hotel', 'seat': 7},
      {'name': 'India', 'seat': 8},
    ];

    final players = [];
    for (var player in seats) {
      players.add(Player(player['name'] as String, player['seat'] as int));
    }

    return players;
  }

  // dealCards() {
  //   round.dealPlayers();
  //   setState(() {
  //     status = 'preFlop';
  //   });
  // }

  dealCards() {
    round = Round(getPlayers());
    round.dealPlayers();
    setState(() {
      round = round;
      status = 'preFlop';
    });

    flop();
    turn();
    river();
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
    var player = round.river();
    print('WINNER!');
    print(player?.name);
    print(player?.seat);
    print(player?.hand.bestHand);
    setState(() {
      status = round.step;
      winningPlayer = player;
    });
    // var timer = Timer(const Duration(seconds: 20), () => endRound());
  }

  endRound() {
    history.add(round);
    setState(() {
      round = Round(getPlayers());
      // seatIdx = seatIdx + 1;
      winningPlayer = null;
      status = 'ante';
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
      endRound: endRound,
      dealCards: dealCards,
      winningPlayer: winningPlayer,
    );
  }
}
