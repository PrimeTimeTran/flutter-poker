import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PlayerHand.dart';
import 'package:flutpoke/utils/Deck.dart';

class PokerTable extends StatefulWidget {
  PokerTable(
      {Key? key,
      required this.cards,
      required this.status,
      required this.dealCards})
      : super(key: key);

  String status;
  final Function dealCards;
  final List<PlayingCard> cards;

  @override
  State<PokerTable> createState() => _PokerTableState();
}

class _PokerTableState extends State<PokerTable> {
  @override
  Widget build(BuildContext context) {
    var cards = widget.cards;
    return Center(
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerHand(
                      idx: 4,
                      cards: [cards[4], cards[5]],
                      status: widget.status),
                  PlayerHand(
                      idx: 5,
                      cards: [cards[2], cards[3]],
                      status: widget.status),
                  PlayerHand(
                      idx: 6,
                      cards: [cards[0], cards[1]],
                      status: widget.status),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerHand(
                        idx: 3,
                        cards: [cards[6], cards[7]],
                        status: widget.status),
                    PlayerHand(
                        idx: 7,
                        cards: [cards[8], cards[9]],
                        status: widget.status),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PlayerHand(
                        idx: 2,
                        cards: [cards[6], cards[7]],
                        status: widget.status),
                    PlayerHand(
                        idx: 8,
                        cards: [cards[8], cards[9]],
                        status: widget.status),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PlayerHand(
                      idx: 1,
                      cards: [cards[0], cards[1]],
                      status: widget.status),
                  PlayerHand(
                      idx: 0,
                      cards: [cards[2], cards[3]],
                      status: widget.status),
                  PlayerHand(
                      idx: 9,
                      cards: [cards[4], cards[5]],
                      status: widget.status),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.dealCards();
                    },
                    child: Container(color: Colors.grey, child: Text('Deal')),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
