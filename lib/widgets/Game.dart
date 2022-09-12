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
  var status = 'ante';
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
    return [Player('Ace', 0), Player('Bill', 1)];
  }

  dealCards() {
    setState(() {
      cards = round.deck.deal(10);
      status = 'started';
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
