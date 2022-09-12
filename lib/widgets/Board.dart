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
    return Container(
      width: 250,
      height: 250,
      child: Row(
        // mainAxisAlignment: widget.align,
        children: [
          ListView.builder(
              itemCount: widget.cards.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, idx) {
                return SizedBox(
                  height: 250,
                  child: SvgPicture.asset(widget.cards[idx].path),
                );
              }),
        ],
      ),
    );
  }
}
