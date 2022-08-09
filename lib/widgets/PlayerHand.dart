import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/utils/Deck.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand(
      {Key? key, required this.idx, required this.cards, required this.status})
      : super(key: key);

  final int idx;
  String status;
  final List<PlayingCard> cards;

  @override
  State<PlayerHand> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
  @override
  Widget build(BuildContext context) {
    var cardOne = widget.cards[0];
    var cardTwo = widget.cards[1];
    if (widget.status == 'ante') {
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
    return Row(
      children: [
        Text(widget.idx.toString()),
        SizedBox(
          height: 75,
          child: SvgPicture.asset("assets/cards/$cardOne.svg"),
        ),
        SizedBox(
          height: 75,
          child: SvgPicture.asset("assets/cards/$cardTwo.svg"),
        ),
      ],
    );
  }
}
