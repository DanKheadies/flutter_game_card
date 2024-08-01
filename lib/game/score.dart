// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Encapsulates a score and the arithmetic to compute it.
class Score {
  final Duration duration;
  final int level;
  final int score;

  const Score._(
    this.duration,
    this.level,
    this.score,
  );

  factory Score(
    Duration duration,
    int difficulty,
    int level,
  ) {
    // The higher the difficulty, the higher the score.
    var score = difficulty;
    // The lower the time to beat the level, the higher the score.
    score *= 10000 ~/ (duration.inSeconds.abs() + 1);
    return Score._(
      duration,
      level,
      score,
    );
  }

  String get formattedTime {
    final buf = StringBuffer();
    if (duration.inHours > 0) {
      buf.write('${duration.inHours}');
      buf.write(':');
    }
    final minutes = duration.inMinutes % Duration.minutesPerHour;
    if (minutes > 9) {
      buf.write('$minutes');
    } else {
      buf.write('0');
      buf.write('$minutes');
    }
    buf.write(':');
    buf.write((duration.inSeconds % Duration.secondsPerMinute)
        .toString()
        .padLeft(2, '0'));
    return buf.toString();
  }

  @override
  String toString() => 'Score<$score,$formattedTime,$level>';
}
