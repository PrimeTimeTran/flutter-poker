import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/classes/Player.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand(
      {Key? key,
      required this.idx,
      required this.cards,
      required this.status,
      required this.player})
      : super(key: key);

  final int idx;
  final Player player;
  String status;
  final List<dynamic> cards;

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
        SvgPicture.asset(widget.player.hand.playerHand[0].path),
        SvgPicture.asset(widget.player.hand.playerHand[1].path)
      ];
    } else {
      return <Widget>[];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.status == 'preround') {
      return Row(
        children: [
          Text(widget.idx.toString()),
          SizedBox(
            height: 75,
            child: SvgPicture.asset("assets/cards/hk.svg", color: Colors.grey),
          ),
          SizedBox(
            height: 75,
            child: SvgPicture.asset(
              "assets/cards/hk.svg",
              color: Colors.grey,
            ),
          ),
        ],
      );
    }

    return Container(
      width: 250,
      height: 250,
      color: Colors.orange,
      child: Column(
        children: [
          Text(widget.idx.toString()),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: getCards(),
          ),
          getOutcome(),
        ],
      ),
    );
  }
}
