import 'package:colorize/colorize.dart';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

void main() {
  final player1 = Player('Loi', 0);
  final player2 = Player('Bob', 1);
  final player3 = Player('John', 2);
  final players = [player1, player2, player3];

  final round = Round(players);
  round.deck.shuffle();
  round.dealPlayers();
  round.flop();
  round.turn();
  round.river();
  round.outcome();
  round.winner();
}
