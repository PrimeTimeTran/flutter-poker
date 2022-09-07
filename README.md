# flutpoke

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

- Back to antie

- Find winning hand from multiple high cards.
- Find winning hand from high cards board.

- Find winning hand from multiple pairs.

- Find winning hand from multiple two pairs.

- Find winning hand from multiple three of a kinds.

- Find winning hand from multiple straights.

- Find winning hand from multiple flushes.

- Find winning hand from multiple full houses.

- Find winning hand from multiple four of a kinds.

- Find winning hand from multiple straight flushes.

- Find winning hand from multiple royal flushes.
