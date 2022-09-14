import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PokerTable.dart';

import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutter/services.dart';

class DealIntent extends Intent {}

class ResetIntent extends Intent {}

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var history = [];
  var status = 'ante';
  Player? winningPlayer;
  var buttonSeatNumber = -1;
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
    final newSeatNumber = buttonSeatNumber + 1 == 9 ? 0 : buttonSeatNumber + 1;
    setState(() {
      round = round;
      status = round.step;
      buttonSeatNumber = newSeatNumber;
    });

    flop();
    turn();
    river();
    history.add(round);

    print('Result!');
    if (round.winner() == 'push') {
      setState(() {
        winningPlayer = null;
      });
      print('Push!');
    } else {
      print('Winner!');
      print(round);
      print(round.winner().name);
      print(round.winner().seat);
    }
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
    if (player != 'push') {
      setState(() {
        status = round.step;
        winningPlayer = player;
      });
    } else {
      setState(() {
        status = round.step;
        winningPlayer = null;
      });
    }
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

  back() {
    round = history[history.length - 2];
    setState(() {
      round = round;
      status = 'river';
      winningPlayer = round.winner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyC): completeRound,
        const SingleActivator(LogicalKeyboardKey.keyD): dealCards,
        const SingleActivator(LogicalKeyboardKey.keyB): back,
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
          buttonSeatNumber: buttonSeatNumber,
        ),
      ),
    );
  }
}
