class Player {
  int money = 1000;
  Player();
}

class PlayingCard {
  String rank;
  String suit;
  int value;
  String path;

  PlayingCard(this.rank, this.suit, this.value, this.path);

  toString() {
    return '$suit$rank';
  }
}

class Deck {
  List<PlayingCard> cards = [];
  Deck() {
    final ranks = [
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      'j',
      'q',
      'k',
      'a',
    ];

    final suits = ['h', 'd', 'c', 's'];

    for (var suit in suits) {
      ranks.asMap().forEach((index, rank) => {
            cards.add(new PlayingCard(
                rank, suit, index, "assets/cards/$suit$rank.svg"))
          });
    }
  }

  toString() {
    return cards.toString();
  }

  shuffle() {
    cards.shuffle();
  }

  cardsWithSuit(String suit) {
    return cards.where((card) => card.suit == suit);
  }

  deal(numOfHands) {
    List<List> handsDealt = [[], [], [], [], [], [], [], [], [], []];
    cards.removeAt(0);

    var handIdx = 0;

    while (handIdx < numOfHands) {
      var card = cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    handIdx = 0;

    while (handIdx < numOfHands) {
      var card = cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    return handsDealt;
  }
}

class Round {
  List board = [];
  int blind = 100;
  int buttonIdx = 0;
  Deck deck = Deck();
  Map table = {
    0: {
      'player': Player(),
    },
    1: {},
    2: {},
    3: {},
    4: {},
    5: {},
    6: {},
    7: {},
    8: {},
  };

  deal() {
    print(table);
  }

  Round();
}

main() {
  final round = Round();
  print(round.deck);
  print(round.deal());
  print(round.deal());
}
