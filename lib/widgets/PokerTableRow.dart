import 'package:flutter/material.dart';

import 'package:flutpoke/classes/Player.dart';
import 'package:flutpoke/widgets/PlayerHand.dart';

class PokerTableRow extends StatelessWidget {
  final String status;
  final MainAxisAlignment alignment;
  final List seatNumbers;
  final List players;
  final bool centerPlayer;
  var winningPlayer;

  PokerTableRow(
      {Key? key,
      required this.seatNumbers,
      required this.status,
      required this.players,
      required this.alignment,
      required this.winningPlayer,
      this.centerPlayer = false})
      : super(key: key);

  getCenterPlayer() {
    if (centerPlayer) {
      return PlayerHand(
        seatNumber: seatNumbers[2],
        status: status,
        player: players[2],
        winningPlayer: winningPlayer,
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
            seatNumber: seatNumbers[0],
            status: status,
            player: players[0],
            winningPlayer: winningPlayer,
          ),
          getCenterPlayer(),
          PlayerHand(
            seatNumber: seatNumbers[1],
              status: status,
            player: players[1],
            winningPlayer: winningPlayer,
          )
        ],
      ),
    );
  }
}
