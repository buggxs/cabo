// Debug round: index of the Cabo caller, index of the player with penalty
// points (-1 = none), indices of the round winners, the already settled points
// per player and whether the round was a kamikaze.
typedef DebugRoundSpec = ({
  int closer,
  int penalty,
  List<int> winners,
  List<int> points,
  bool isKamikaze,
});

// 15 rounds that contain every rule constellation at least once: caller
// wins (1, 2, 6, 7, ...), caller loses with +5 (3, 5, 8, 10), tie won by the
// caller (4), two round winners (5), kamikaze (13) and thereby a precision
// landing on exactly 100 for Ben.
const List<DebugRoundSpec> debugRunningGameRounds = <DebugRoundSpec>[
  (
    closer: 0,
    penalty: -1,
    winners: <int>[0],
    points: <int>[0, 6, 4, 8],
    isKamikaze: false,
  ),
  (
    closer: 3,
    penalty: -1,
    winners: <int>[3],
    points: <int>[5, 3, 4, 0],
    isKamikaze: false,
  ),
  (
    closer: 1,
    penalty: 1,
    winners: <int>[2],
    points: <int>[6, 9, 0, 5],
    isKamikaze: false,
  ),
  (
    closer: 2,
    penalty: -1,
    winners: <int>[2],
    points: <int>[3, 5, 0, 6],
    isKamikaze: false,
  ),
  (
    closer: 3,
    penalty: 3,
    winners: <int>[0, 1],
    points: <int>[0, 0, 2, 11],
    isKamikaze: false,
  ),
  (
    closer: 1,
    penalty: -1,
    winners: <int>[1],
    points: <int>[4, 0, 3, 5],
    isKamikaze: false,
  ),
  (
    closer: 0,
    penalty: -1,
    winners: <int>[0],
    points: <int>[0, 2, 3, 4],
    isKamikaze: false,
  ),
  (
    closer: 2,
    penalty: 2,
    winners: <int>[3],
    points: <int>[4, 3, 8, 0],
    isKamikaze: false,
  ),
  (
    closer: 3,
    penalty: -1,
    winners: <int>[3],
    points: <int>[5, 2, 2, 0],
    isKamikaze: false,
  ),
  (
    closer: 0,
    penalty: 0,
    winners: <int>[2],
    points: <int>[9, 3, 0, 6],
    isKamikaze: false,
  ),
  (
    closer: 1,
    penalty: -1,
    winners: <int>[1],
    points: <int>[2, 0, 2, 2],
    isKamikaze: false,
  ),
  (
    closer: 2,
    penalty: -1,
    winners: <int>[2],
    points: <int>[2, 3, 0, 3],
    isKamikaze: false,
  ),
  (
    closer: 1,
    penalty: -1,
    winners: <int>[0],
    points: <int>[0, 50, 50, 50],
    isKamikaze: true,
  ),
  (
    closer: 1,
    penalty: -1,
    winners: <int>[1],
    points: <int>[4, 0, 3, 5],
    isKamikaze: false,
  ),
  (
    closer: 3,
    penalty: -1,
    winners: <int>[3],
    points: <int>[3, 2, 4, 0],
    isKamikaze: false,
  ),
];
