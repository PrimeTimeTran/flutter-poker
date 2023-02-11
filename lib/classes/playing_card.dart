class PlayingCard {
  String rank;
  String suit;
  int value;
  String path;

  PlayingCard(this.rank, this.suit, this.value, this.path);

  @override
  toString() {
    return '$rank$suit';
  }
}
