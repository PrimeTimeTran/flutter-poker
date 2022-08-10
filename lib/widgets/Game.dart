import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PokerTable.dart';

import 'package:flutpoke/utils/Deck.dart';

class Game extends StatefulWidget {
  Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late Deck deck;

  // preround, ante, preflop, flop, turn, river
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

  dealCards() {
    deck = Deck();
    deck.shuffle();
    setState(() {
      cards = deck.deal(10);
      status = 'started';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PokerTable(
      cards: cards,
      status: status,
      dealCards: dealCards,
    );
  }
}
