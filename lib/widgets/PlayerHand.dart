import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/classes/Player.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand(
      {Key? key,
      required this.seatNumber,
      required this.status,
      required this.winningPlayer,
      required this.player})
      : super(key: key);

  final int seatNumber;
  final Player player;
  Player? winningPlayer;
  String status;

  @override
  State<PlayerHand> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  getOutcome() {
    if (widget.status == 'river') {
      return Text(widget.player.hand.outcome);
    } else {
      return Container();
    }
  }

  getCards() {
    if (widget.player.hand.playerHand.length == 2) {
      return <Widget>[
        SizedBox(
          width: 100,
          height: 100,
          child: SvgPicture.asset(widget.player.hand.playerHand[0].path),
        ),
        SizedBox(
          width: 100,
          height: 100,
          child: SvgPicture.asset(widget.player.hand.playerHand[1].path),
        ),
      ];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    var winner = false;

    if (widget.winningPlayer is Player) {
      winner = widget.winningPlayer?.seat == widget.seatNumber;
    }

    return Container(
      width: 250,
      height: 250,
      alignment: Alignment.center,
      color: winner ? Colors.orange : Colors.grey,
      child: Center(
        child: Column(
          children: [
            Text(widget.seatNumber.toString()),
            Text(widget.player.name),
            Row(
              children: getCards(),
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            getOutcome(),
          ],
        ),
      ),
    );
  }
}
