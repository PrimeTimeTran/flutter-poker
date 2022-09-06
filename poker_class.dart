import 'package:colorize/colorize.dart';
import 'dart:math';

class Player {
  int seat;
  String name;
  int money = 1000;
  Player(this.name, this.seat);
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

class Hand {
  List<PlayingCard> cards = [];

  add(card) {
    cards.add(card);
  }

  high(board) {
    cards.addAll(board);
    cards.sort((a, b) => b.value.compareTo(a.value));
    // print(cards);
    final ranks = cards.map((c) => c.rank);
    var map = Map();
    ranks.forEach((e) {
      if (!map.containsKey(e)) {
        map[e] = 1;
      } else {
        map[e] += 1;
      }
    });

    // print(map);

    if (fourOfAKind(map)) {
      print('Four of a kind!');
    } else if (straight(map)) {
      print('Straight!');
    } else if (threeOfAKind(map)) {
      print('Three of a kind!');
    } else if (twoPaired()) {
      print('Two Pair');
    } else if (paired()) {
      print('Pair');
    } else {
      print('High Card');
    }
  }

  paired() {
    final ranks = cards.map((c) => c.rank);
    var n = ranks.toSet().toList();
    return n.length == 6;
  }

  twoPaired() {
    final ranks = cards.map((c) => c.rank);
    var n = ranks.toSet().toList();
    return n.length == 5;
  }

  threeOfAKind(map) {
    return map.values.any((e) => e == 3);
  }

  fourOfAKind(map) {
    return map.values.any((e) => e == 4);
  }

  straight(map) {
    final dp = [1, 1, 1, 1, 1, 1, 1];
    final ranks = cards.map((c) => c.value);
    final nums = ranks.toSet().toList();
    for (var i = 0; i < nums.length; i++) {
      for (var j = 0; j < nums.length; j++) {
        if (nums[i] == nums[j] - 1) {
          dp[i] = max(dp[i], dp[j] + 1);
        }
      }
    }
    var res = 1;
    for (var i = 0; i < nums.length; i++) {
      if (res < dp[i]) {
        res = dp[i];
      }
    }
    return res == 5;
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
    return cards;
  }

  cardsWithSuit(String suit) {
    return cards.where((card) => card.suit == suit);
  }
}

class Round {
  String step = 'ante';
  int blind = 100;
  List<PlayingCard> board = [];
  List players = [];
  List handsDealt = [];
  int buttonIdx = 0;
  Deck deck = Deck();

  dealPlayers() {
    final numOfHands = players.length;
    handsDealt = [Hand(), Hand()];
    deck.cards.removeAt(0);

    var handIdx = 0;

    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }

    handIdx = 0;

    while (handIdx < numOfHands) {
      var card = deck.cards.removeAt(0);
      handsDealt[handIdx].add(card);
      handIdx++;
    }
    step = 'pre-flop';

    return handsDealt;
  }

  flop() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    var card2 = deck.cards.removeAt(0);
    var card3 = deck.cards.removeAt(0);

    board = [card1, card2, card3];
    step = 'pre-turn';
    return board;
  }

  turn() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'pre-river';
    return board;
  }

  river() {
    deck.cards.removeAt(0);
    var card1 = deck.cards.removeAt(0);
    board.add(card1);
    step = 'post-river';
    return board;
  }

  winner() {
    Colorize string = new Colorize("Winner");
    string.green();
    print(string);

    final hand1 = handsDealt[0].high(board);
  }

  Round(this.players);
}

main() {
  final player1 = Player('Loi', 1);
  final player2 = Player('Bob', 0);
  final players = [player1, player2];
  final round = Round(players);
  round.deck.shuffle();
  round.dealPlayers();
  round.flop();
  round.turn();
  round.river();

  round.winner();
}
