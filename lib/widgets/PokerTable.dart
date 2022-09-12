import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/PlayerHand.dart';
import 'package:flutpoke/widgets/PokerTableRow.dart';

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
                children: const [
                  Text('Hello'),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              PokerTableRow(
                  status: 'hi',
                  seats: const [8, 0],
                  cards: widget.cards,
                  alignment: MainAxisAlignment.spaceAround),
              PokerTableRow(
                  status: 'hi',
                  seats: const [7, 1],
                  cards: widget.cards,
                  alignment: MainAxisAlignment.spaceBetween),
              PokerTableRow(
                  status: 'hi',
                  seats: const [6, 2],
                  cards: widget.cards,
                  alignment: MainAxisAlignment.spaceBetween),
              PokerTableRow(
                status: 'hi',
                seats: const [5, 3, 4],
                cards: widget.cards,
                alignment: MainAxisAlignment.spaceAround,
                centerPlayer: true,
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
