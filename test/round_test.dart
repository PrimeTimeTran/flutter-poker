import 'package:test/test.dart';
import 'package:flutpoke/classes/deck.dart';
import 'package:flutpoke/classes/round.dart';
import 'package:flutpoke/classes/player.dart';
import 'package:flutpoke/classes/playing_card.dart';

void main() {
  final deck = Deck();
  final cards = deck.cards;

  final player1 = Player('Loi', 0);
  final player2 = Player('Bob', 1);
  final player3 = Player('John', 2);

  getCard(code) {
    return cards.firstWhere((c) => '${c.rank}${c.suit}' == code);
  }

  test('2 players if begun with 2 players', () {
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.length, 2);
  });

  test('3 players if begun with 3 players', () {
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayers();
    expect(round.players.length, 3);
  });

  test('2 player round to have 39 cards in deck after final action', () {
    final players = [player1, player2];
    final round = Round(players);

    round.deck.shuffle();
    round.dealPlayers();

    round.flop();
    round.turn();
    round.river();

    expect(round.deck.remainingCards().length, 39);
  });

  test('Straight flush beats four of a kind', () {
    final board = <PlayingCard>[];
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('kd'));
    round.dealPlayerBySeat(0, getCard('qd'));

    round.dealPlayerBySeat(1, getCard('2h'));
    round.dealPlayerBySeat(1, getCard('2d'));

    board.add(getCard('jd'));
    board.add(getCard('10d'));
    board.add(getCard('9d'));
    board.add(getCard('2c'));
    board.add(getCard('2s'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  test('Royal flush beats straight flush', () {
    final board = <PlayingCard>[];
    final players = [player2, player1];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('ad'));
    round.dealPlayerBySeat(0, getCard('kd'));

    round.dealPlayerBySeat(1, getCard('9d'));
    round.dealPlayerBySeat(1, getCard('8d'));

    board.add(getCard('qd'));
    board.add(getCard('jd'));
    board.add(getCard('10d'));
    board.add(getCard('2c'));
    board.add(getCard('2s'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  // TODO order matters
  test('Higher straight flush beats lower straight flush', () {
    final board = <PlayingCard>[];
    final players = [player1, player2];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('kd'));
    round.dealPlayerBySeat(0, getCard('qd'));

    round.dealPlayerBySeat(1, getCard('8d'));
    round.dealPlayerBySeat(1, getCard('7d'));

    board.add(getCard('jd'));
    board.add(getCard('10d'));
    board.add(getCard('9d'));
    board.add(getCard('2c'));
    board.add(getCard('2s'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  test('High card wins', () {
    final board = <PlayingCard>[];
    final players = [player2, player1];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('ad'));
    round.dealPlayerBySeat(0, getCard('kd'));

    round.dealPlayerBySeat(1, getCard('qd'));
    round.dealPlayerBySeat(1, getCard('jd'));

    board.add(getCard('2h'));
    board.add(getCard('3h'));
    board.add(getCard('4d'));
    board.add(getCard('6h'));
    board.add(getCard('7h'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  // ignore: todo
  // TODO High cards win

  
  test('Top pair wins', () {
    final board = <PlayingCard>[];
    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('ah'));
    round.dealPlayerBySeat(0, getCard('jh'));

    round.dealPlayerBySeat(1, getCard('kh'));
    round.dealPlayerBySeat(1, getCard('qh'));

    round.dealPlayerBySeat(2, getCard('6d'));
    round.dealPlayerBySeat(2, getCard('8c'));

    board.add(getCard('ad'));
    board.add(getCard('kd'));
    board.add(getCard('4d'));
    board.add(getCard('6h'));
    board.add(getCard('7h'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player1.seat);
  });

  // TODO Same top pair high card
  test('Shared pair with high card wins', () {
    final board = <PlayingCard>[];

    final players = [player1, player2, player3];
    final round = Round(players);

    round.dealPlayerBySeat(0, getCard('2c'));
    round.dealPlayerBySeat(0, getCard('3c'));

    round.dealPlayerBySeat(1, getCard('kd'));
    round.dealPlayerBySeat(1, getCard('qd'));

    round.dealPlayerBySeat(2, getCard('2s'));
    round.dealPlayerBySeat(2, getCard('3s'));

    board.add(getCard('ad'));
    board.add(getCard('ah'));
    board.add(getCard('4d'));
    board.add(getCard('6h'));
    board.add(getCard('7h'));

    round.dealCardsForTest(board);
    round.updatePlayerHandAndBoard();

    expect(round.winner().seat, player2.seat);
  });

}
