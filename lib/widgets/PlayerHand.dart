import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/classes/player.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand({
    Key? key,
    required this.player,
    required this.status,
    required this.seatNumber,
    required this.winningPlayer,
    required this.buttonSeatNumber,
  }) : super(key: key);

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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
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
        ],
      );
    } else {
      return Container(
        width: 125,
        height: 125,
        decoration: const BoxDecoration(
          color: Colors.blue,
          shape: BoxShape.circle,
        ),
      );
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

    return Tooltip(
      height: 100,
      preferBelow: false,
      padding: const EdgeInsets.all(8.0),
      message: "A lot of good information",
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(25),
      ),
      textStyle: const TextStyle(
        fontSize: 20,
      ),
      child: Container(
        width: 350,
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
          color: winner ? Colors.blue.shade900 : Colors.black54,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: winner ? Colors.blue : Colors.grey, spreadRadius: 3),
          ],
        ),
        child: Center(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.seatNumber.toString()),
                    Text(
                      widget.player.name,
                      style: TextStyle(color: buttonColor),
                    ),
                    Text(widget.player.money.toString()),
                    getOutcome()
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: getCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
