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
      state: empty | playing | fold
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
  status: preround | ante | preflop | flop | turn | river,
}
```
