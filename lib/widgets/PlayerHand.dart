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
  var winningPlayer;
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
        Container(
          height: 100,
          width: 100,
          child: SvgPicture.asset(widget.player.hand.playerHand[0].path),
        ),
        Container(
          height: 100,
          width: 100,
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

    if (widget.winningPlayer != 'push') {
      winner = widget.winningPlayer?.seat == widget.seatNumber;
    }

    return Container(
      width: 250,
      height: 250,
      color: winner ? Colors.orange : Colors.grey,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          children: [
            Text(widget.seatNumber.toString()),
            Text(widget.player.name),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: getCards(),
            ),
            getOutcome(),
          ],
        ),
      ),
    );
  }
}
