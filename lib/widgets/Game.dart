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

  // ante, started,
  var status = 'ante';
  late List<PlayingCard> cards = [];

  @override
  void initState() {
    super.initState();
    deck = new Deck();
    deck.shuffle();
    cards = deck.getCards();
  }

  dealCards() {
    deck.shuffle();
    deck.deal(10);
    cards = deck.cards;
    debugPrint(cards.toString());
    setState(() {
      status = 'started';
      cards = cards;
      // _hands = widget.deck.cards.deal(10);
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
