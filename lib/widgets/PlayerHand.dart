import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/classes/Player.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand({
    Key? key,
    required this.player,
    required this.status,
    required this.seatNumber,
    required this.winningPlayer,
    required this.buttonSeatNumber,
  })
      : super(key: key);

  final int seatNumber;
  final int buttonSeatNumber;
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
          height: 150,
          child: SvgPicture.asset(widget.player.hand.playerHand[0].path),
        ),
        SizedBox(
          width: 100,
          height: 150,
          child: SvgPicture.asset(widget.player.hand.playerHand[1].path),
        ),
      ];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    final button = widget.seatNumber == widget.buttonSeatNumber;
    final buttonColor = button ? Colors.red : Colors.black;
    var winner = false;

    if (widget.winningPlayer is Player) {
      winner = widget.winningPlayer?.seat == widget.seatNumber;
    }

    return Container(
      width: 350,
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      alignment: Alignment.center,
      color: winner ? Colors.orange : Colors.grey,
      child: Center(
        child: Row(
          children: [
            Expanded(
              child: Container(
                // color: Colors.red,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.seatNumber.toString()),
                    Text(
                      widget.player.name,
                      style: TextStyle(color: buttonColor),
                    ),
                    getOutcome()
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: getCards(),
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
