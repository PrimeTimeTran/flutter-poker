# flutpoke

Play poker with Flutter

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

- Back to antie