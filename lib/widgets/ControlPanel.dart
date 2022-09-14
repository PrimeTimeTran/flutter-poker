import 'package:flutter/material.dart';

class ControlPanel extends StatefulWidget {
  ControlPanel({
    Key? key,
    required this.flop,
    required this.turn,
    required this.river,
    required this.endRound,
    required this.dealCards,
    required this.completeRound,
  }) : super(key: key);

  final Function flop;
  final Function turn;
  final Function river;
  final Function endRound;
  final Function dealCards;
  final Function completeRound;

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            GestureDetector(
              onTap: () {
                widget.completeRound();
              },
              child: Container(color: Colors.grey, child: Text('Round')),
            ),
            GestureDetector(
              onTap: () {
                widget.dealCards();
              },
              child: Container(color: Colors.grey, child: Text('Deal')),
            ),
            GestureDetector(
              onTap: () {
                widget.flop();
              },
              child: Container(color: Colors.grey, child: Text('Flop')),
            ),
            GestureDetector(
              onTap: () {
                widget.turn();
              },
              child: Container(color: Colors.grey, child: Text('Turn')),
            ),
            GestureDetector(
              onTap: () {
                widget.river();
              },
              child: Container(color: Colors.grey, child: Text('River')),
            ),
            GestureDetector(
              onTap: () {
                widget.endRound();
              },
              child: Container(color: Colors.grey, child: Text('Next Round')),
            ),
          ],
        ),
      ),
    );
  }
}
