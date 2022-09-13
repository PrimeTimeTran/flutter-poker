import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/Board.dart';
import 'package:flutpoke/classes/Round.dart';
import 'package:flutpoke/classes/Player.dart';
import 'package:flutpoke/widgets/PlayerHand.dart';
import 'package:flutpoke/widgets/PokerTableRow.dart';

class PokerTable extends StatefulWidget {
  PokerTable(
      {Key? key,
      required this.status,
      required this.dealCards,
      required this.flop,
      required this.turn,
      required this.river,
      required this.round})
      : super(key: key);

  String status;
  final Round round;
  final Function dealCards;
  final Function flop;
  final Function turn;
  final Function river;

  @override
  State<PokerTable> createState() => _PokerTableState();
}

class _PokerTableState extends State<PokerTable> {
  @override
  Widget build(BuildContext context) {
    final players = widget.round.players;
    final status = widget.status;

    return Center(
      child: Stack(
        children: [
          Positioned.fill(
            top: 100,
            left: 150,
            right: 150,
            bottom: 100,
            child: Container(
              color: Colors.blue,
              child: Column(
                children: [
                  Text(widget.round.step),
                ],
              ),
            ),
          ),
          Column(
            children: <Widget>[
              PokerTableRow(
                  status: status,
                  seats: const [8, 0],
                  players: [players[8], players[0]],
                  alignment: MainAxisAlignment.spaceAround),
              PokerTableRow(
                  status: status,
                  seats: const [7, 1],
                  players: [players[7], players[1]],
                  alignment: MainAxisAlignment.spaceBetween),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Board(cards: widget.round.board),
                  ],
                ),
              ),
              PokerTableRow(
                  status: status,
                  seats: const [6, 2],
                  players: [players[6], players[2]],
                  alignment: MainAxisAlignment.spaceBetween),
              PokerTableRow(
                status: status,
                seats: const [5, 3, 4],
                players: [players[5], players[3], players[4]],
                alignment: MainAxisAlignment.spaceAround,
                centerPlayer: true,
              ),
              Expanded(
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
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.flop();
                        },
                        child:
                            Container(color: Colors.grey, child: Text('Flop')),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.turn();
                        },
                        child:
                            Container(color: Colors.grey, child: Text('Turn')),
                      ),
                      GestureDetector(
                        onTap: () {
                          widget.river();
                        },
                        child:
                            Container(color: Colors.grey, child: Text('River')),
                      ),
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
