import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PokerTable.dart';

import 'package:flutpoke/classes/Round.dart';
import 'package:flutpoke/classes/Player.dart';
import 'package:flutter/services.dart';

class DealIntent extends Intent {}

class ResetIntent extends Intent {}

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

  dealCards() {
    round.dealPlayers();
    setState(() {
      status = 'preFlop';
    });
  }

  completeRound() {
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
    setState(() {
      status = round.step;
      winningPlayer = player;
    });
    // var timer = Timer(const Duration(seconds: 20), () => endRound());
  }

  endRound() {
    history.add(round);
    setState(() {
      status = 'ante';
      winningPlayer = null;
      round = Round(getPlayers());
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyC): completeRound,
        const SingleActivator(LogicalKeyboardKey.keyD): dealCards,
        const SingleActivator(LogicalKeyboardKey.keyR): completeRound,
      },
      child: Focus(
        autofocus: true,
        child: PokerTable(
          flop: flop,
          turn: turn,
          river: river,
          round: round,
          status: status,
          endRound: endRound,
          dealCards: dealCards,
          completeRound: completeRound,
          winningPlayer: winningPlayer,
        ),
      ),
    );
    // return Shortcuts(
    //   shortcuts: {
    //     LogicalKeySet(LogicalKeyboardKey.keyD): DealIntent(),
    //     LogicalKeySet(LogicalKeyboardKey.keyR): ResetIntent()
    //   },
    //   child: Actions(
    //     actions: {
    //       DealIntent:
    //           CallbackAction<DealIntent>(onInvoke: (intent) => dealCards()),
    //       ResetIntent:
    //           CallbackAction<ResetIntent>(onInvoke: (intent) => endRound()),
    //     },
    // child: PokerTable(
    //   flop: flop,
    //   turn: turn,
    //   river: river,
    //   round: round,
    //   status: status,
    //   endRound: endRound,
    //   dealCards: dealCards,
    //   completeRound: completeRound,
    //   winningPlayer: winningPlayer,
    // ),
    //   ),
    // );
    // return PokerTable(
    //   flop: flop,
    //   turn: turn,
    //   river: river,
    //   round: round,
    //   status: status,
    //   endRound: endRound,
    //   dealCards: dealCards,
    //   winningPlayer: winningPlayer,
    // );
  }
}
