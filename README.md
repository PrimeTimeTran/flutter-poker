# flutpoke

![Poke](https://s4.gifyu.com/images/demoabe973cb0e4ec1ab.gif)
[Demo](https://chic-wisp-f1f009.netlify.app/#/)
Flutter implementation of Poker.

## Getting Started

```dart
final state = {
  playerIds: [],
  board: [],
  blind: 100,
  buttonIdx: 0,
  playerCount: 2,
  hands: [
    0: {
      state: 
      cards: [],
    },
    1: [],
    3: [],
    4: [],
  ],
  handHistory: [
    {

    }
  ]

  deck: [],
  cards: [[], []],
  status: ante | preflop | flop | turn | river,
}
```

- Count num of players
  Collect blinds
  Identify button position
  Deal cards

- Small blind action
  Action moves left until button closes round with their action

- Small blind action
  Action moves left until button closes round with their action

- Small blind action
  Action moves left until button closes round with their action

- Small blind action
  Action moves left until button closes round with their action

- Back to ante.
- Back to again.


[x] Find high card winning hand.

[x] Find pair winning hand.

[x] Find two pair winning hand.

[x] Find trips winning hand.

[x] Find straight winning hand.

[x] Find flush winning hand.

[x] Find full house winning hand.

[x] Find quads winning hand.

[x] Find straight flush winning hand.

[x] Find royal flush winning hand.

[x] Find pushes in the winning hands.

[ ] Take ante from each player.

[ ] Add raise.

[ ] Add call.

[ ] Add fold.

[ ] Split pot between winning hands.

[ ] Split pot between pushed hands.

[ ] Split pot between all in players.

[ ] Add button.

[ ] Move button after round.

[ ] Prompt winning hands when push.

[ ] Show probability of winning hands on each round.