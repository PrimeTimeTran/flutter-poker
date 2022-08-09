# flutpoke

Play poker with Flutter

## Getting Started

```dart
final state = {
  deck: [],
  board: [],
  blind: 100,
  buttonIdx: 0,
  playerIds: [],
  playerCount: 2,
  status: inactive | active,
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
}
```