import 'package:flutter/material.dart';

import 'package:flutpoke/classes/Player.dart';
import 'package:flutpoke/widgets/PlayerHand.dart';

class PokerTableRow extends StatelessWidget {
  final List players;
  final String status;
  Player? winningPlayer;
  final List seatNumbers;
  final bool centerPlayer;
  final int buttonSeatNumber;
  final MainAxisAlignment alignment;

  PokerTableRow({
    Key? key,
    required this.seatNumbers,
    required this.status,
    required this.players,
    required this.alignment,
    required this.winningPlayer,
    required this.buttonSeatNumber,
    this.centerPlayer = false,
  })
      : super(key: key);

  getCenterPlayer() {
    if (centerPlayer) {
      return PlayerHand(
        status: status,
        player: players[2],
        seatNumber: seatNumbers[2],
        winningPlayer: winningPlayer,
        buttonSeatNumber: buttonSeatNumber, 
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          PlayerHand(
            status: status,
            player: players[0],
            seatNumber: seatNumbers[0],
            winningPlayer: winningPlayer,
            buttonSeatNumber: buttonSeatNumber,
          ),
          getCenterPlayer(),
          PlayerHand(
            status: status,
            player: players[1],
            seatNumber: seatNumbers[1],
            winningPlayer: winningPlayer,
            buttonSeatNumber: buttonSeatNumber,
          )
        ],
      ),
    );
  }
}
