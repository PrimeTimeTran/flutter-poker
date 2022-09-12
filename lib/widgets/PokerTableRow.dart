import 'package:flutter/material.dart';
import 'package:flutpoke/widgets/PlayerHand.dart';

class PokerTableRow extends StatelessWidget {
  final String status;
  final List<dynamic> cards;
  final MainAxisAlignment alignment;
  final List seats;
  final bool centerPlayer;

  const PokerTableRow(
      {Key? key,
      required this.status,
      required this.cards,
      required this.alignment,
      required this.seats,
      this.centerPlayer = false})
      : super(key: key);

  getPlayerCards(idx) {
    return cards[idx];
  }

  getCenterPlayer() {
    if (centerPlayer) {
      return PlayerHand(
        idx: seats[2],
        cards: getPlayerCards(seats[2]),
        status: status,
        align: MainAxisAlignment.center,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 4,
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          PlayerHand(
            idx: seats[0],
            status: status,
            cards: getPlayerCards(seats[0]),
            align: MainAxisAlignment.end,
          ),
          getCenterPlayer(),
          PlayerHand(
              idx: seats[1],
              status: status,
              cards: getPlayerCards(seats[1]),
              align: MainAxisAlignment.start
          ),
        ],
      ),
    );
  }
}
