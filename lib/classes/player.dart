import 'package:flutpoke/classes/hand.dart';

class Player {
  int seat;
  String name;
  late Hand hand;
  int money = 1000;
  Player(this.name, this.seat);
}
