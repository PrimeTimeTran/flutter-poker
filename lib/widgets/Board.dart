import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

class Board extends StatefulWidget {
  Board({Key? key, required this.cards}) : super(key: key);

  final List<dynamic> cards;

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1000,
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.cards.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (ctx, idx) {
              return SizedBox(
                height: 100,
                width: 100,
                child: SvgPicture.asset(widget.cards[idx].path),
              );
            },
          ),
        ],
      ),
    );
  }
}
