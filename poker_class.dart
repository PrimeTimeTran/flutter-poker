main() {
  final hand1 = {
    'ranking': 1,
  };

  final hand2 = {
    'ranking': 2,
  };
  final hand3 = {
    'ranking': 1,
  };

  List players = [hand1, hand2, hand3];

  players.sort((a, b) => b['ranking']!.compareTo(a['ranking']!));
  print(players);
}
