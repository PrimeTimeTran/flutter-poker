import 'package:flutter/material.dart';

import 'package:flutpoke/widgets/Board.dart';
import 'package:flutpoke/classes/Round.dart';
import 'package:flutpoke/classes/Player.dart';
import 'package:flutpoke/widgets/PokerTableRow.dart';

class PokerTable extends StatefulWidget {
  PokerTable(
      {Key? key,
      required this.status,
      required this.dealCards,
      required this.flop,
      required this.turn,
      required this.river,
      required this.winningPlayer,
      required this.endRound,
      required this.round})
      : super(key: key);

  String status;
  final Round round;
  final Function dealCards;
  final Function flop;
  final Function turn;
  final Function river;
  final Function endRound;
  var winningPlayer;

  @override
  State<PokerTable> createState() => _PokerTableState();
}

class _PokerTableState extends State<PokerTable> {
  @override
  Widget build(BuildContext context) {
    final status = widget.status;
    final players = widget.round.players;
    final winningPlayer = widget.winningPlayer;

    print('Poker Table');
    print(players[0]);
    print(players[8]);

    players.sort((a, b) => a.seat.compareTo(b.seat));

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
                seatNumbers: const [8, 0],
                winningPlayer: winningPlayer,
                players: [players[8], players[0]],
                alignment: MainAxisAlignment.spaceAround,
              ),
              PokerTableRow(
                status: status,
                seatNumbers: const [7, 1],
                winningPlayer: winningPlayer,
                players: [players[7], players[1]],
                alignment: MainAxisAlignment.spaceBetween,
              ),
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
                seatNumbers: const [6, 2],
                winningPlayer: winningPlayer,
                players: [players[6], players[2]],
                alignment: MainAxisAlignment.spaceBetween,
              ),
              PokerTableRow(
                status: status,
                centerPlayer: true,
                seatNumbers: const [5, 3, 4],
                winningPlayer: winningPlayer,
                alignment: MainAxisAlignment.spaceAround,
                players: [players[5], players[3], players[4]],
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
                      GestureDetector(
                        onTap: () {
                          widget.endRound();
                        },
                        child: Container(
                            color: Colors.grey, child: Text('Next Round')),
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
