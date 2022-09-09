import 'package:colorize/colorize.dart';

printOutcome(round) {
  Colorize string = Colorize("\n------------------");
  string.green();
  print(string);

  print(round.board);
  print('\n');
  for (var player in round.players) {
    print(player.hand.playerHand);
    print(player.hand.highHand);
  }
  print(string);
  print('\n');
}
