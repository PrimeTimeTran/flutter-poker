import 'package:colorize/colorize.dart';

import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/hand.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

void main() {
  //First Method - update
  List myList = [1, 2, 3];
  myList[0] = 123;
  print(myList);

  //Second Method - using .replaceRange() method
  var myList2 = [10, 20, 30, 40, 50]
  myList2.replaceRange(0, 3, [11, 21]);
  print(myList2);
}
