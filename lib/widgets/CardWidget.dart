import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({Key? key, required this.rank, required this.suit})
      : super(key: key);

  final String rank;
  final String suit;

  Widget getIcon(suit) {
    return Container(
      height: 30,
      width: 20,
      child: SvgPicture.asset("assets/cards/suits/$suit.svg"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 250,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
      padding: EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Text(rank),
                  getIcon(suit),
                ],
              )
            ],
          ),
          Expanded(
            flex: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getIcon(suit),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RotatedBox(
                quarterTurns: 2,
                child: Column(
                  children: [
                    Text(rank),
                    getIcon(suit),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
