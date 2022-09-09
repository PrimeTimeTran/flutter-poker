import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PlayerHand.dart';
import 'package:flutpoke/classes/Deck.dart';

class PokerTable extends StatefulWidget {
  PokerTable(
      {Key? key,
      required this.cards,
      required this.status,
      required this.dealCards})
      : super(key: key);

  String status;
  final Function dealCards;
  final List<List> cards;

  @override
  State<PokerTable> createState() => _PokerTableState();
}

class _PokerTableState extends State<PokerTable> {
  getPlayerCards(idx) {
    return widget.cards[idx];
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            top: 100,
            left: 150,
            right: 150,
            bottom: 150,
            child: Container(
              color: Colors.red,
              child: Column(
                children: [
                  Text('Hello'),
                  Text('Hello'),
                  Text('Hello'),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      PlayerHand(
                        idx: 4,
                        status: widget.status,
                        cards: getPlayerCards(4),
                      ),
                      PlayerHand(
                        idx: 5,
                        cards: getPlayerCards(5),
                        status: widget.status,
                      ),
                      PlayerHand(
                        idx: 6,
                        status: widget.status,
                        cards: getPlayerCards(6),
                      ),
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
                          status: widget.status,
                          cards: getPlayerCards(3),
                        ),
                        PlayerHand(
                          idx: 7,
                          status: widget.status,
                          cards: getPlayerCards(7),
                        ),
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
                          status: widget.status,
                          cards: getPlayerCards(2),
                        ),
                        PlayerHand(
                          idx: 8,
                          status: widget.status,
                          cards: getPlayerCards(8),
                        ),
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
                        status: widget.status,
                        cards: getPlayerCards(1),
                      ),
                      PlayerHand(
                        idx: 0,
                        status: widget.status,
                        cards: getPlayerCards(0),
                      ),
                      PlayerHand(
                        idx: 9,
                        status: widget.status,
                        cards: getPlayerCards(9),
                      ),
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
                        child:
                            Container(color: Colors.grey, child: Text('Deal')),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
