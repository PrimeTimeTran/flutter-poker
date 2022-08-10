import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:flutpoke/utils/Deck.dart';

class PlayerHand extends StatefulWidget {
  PlayerHand(
      {Key? key, required this.idx, required this.cards, required this.status})
      : super(key: key);

  final int idx;
  String status;
  final List<dynamic> cards;

  @override
  State<PlayerHand> createState() => _PlayerHandState();
}

class _PlayerHandState extends State<PlayerHand> {
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
      width: 100,
      height: 100,
      child: Row(
        children: [
          Text(widget.idx.toString()),
          ListView.builder(
              itemCount: widget.cards.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, idx) {
                return SizedBox(
                  height: 75,
                  child: SvgPicture.asset(widget.cards[idx].path),
                );
              }),
        ],
      ),
    );
  }
}
