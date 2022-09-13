import 'package:flutter/material.dart';

import 'package:flutpoke/classes/Player.dart';
import 'package:flutpoke/widgets/PlayerHand.dart';

class PokerTableRow extends StatelessWidget {
  final String status;
  final MainAxisAlignment alignment;
  final List seats;
  final List players;
  final bool centerPlayer;

  const PokerTableRow(
      {Key? key,
      required this.seats,
      required this.status,
      required this.players,
      required this.alignment,
      this.centerPlayer = false})
      : super(key: key);

  getCenterPlayer() {
    if (centerPlayer) {
      return PlayerHand(
        idx: seats[2],
        cards: players[2].hand.playerHand,
        status: status,
        player: players[2],
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
            idx: seats[0],
            status: status,
            player: players[0],
            cards: players[0].hand.playerHand,
          ),
          getCenterPlayer(),
          PlayerHand(
              idx: seats[1],
              status: status,
            player: players[1],
            cards: players[1].hand.playerHand,
          )
        ],
      ),
    );
  }
}
