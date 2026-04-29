import 'package:chess_app/core/basics/duration_extensions.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchEndDialog extends StatelessWidget {
  final POVResult result;
  final MatchResult matchResult;
  final ConnectionMode connectionMode;
  final String whitePlayerName;
  final String blackPlayerName;
  final int moveCount;
  final Duration duration;

  static Future<void> show(
    BuildContext context, {
    required POVResult result,
    required MatchResult matchResult,
    required ConnectionMode connectionMode,
    required String whitePlayerName,
    required String blackPlayerName,
    required int moveCount,
    required Duration duration,
  }) {
    assert(
      result != POVResult.ongoing,
      "Cannot show end dialog for ongoing match",
    );
    return showDialog(
      context: context,
      barrierColor: Colors.black54,
      barrierDismissible: true,
      builder: (_) => MatchEndDialog._(
        result: result,
        matchResult: matchResult,
        connectionMode: connectionMode,
        whitePlayerName: whitePlayerName,
        blackPlayerName: blackPlayerName,
        moveCount: moveCount,
        duration: duration,
      ),
    );
  }

  const MatchEndDialog._({
    required this.result,
    required this.matchResult,
    required this.connectionMode,
    required this.whitePlayerName,
    required this.blackPlayerName,
    required this.moveCount,
    required this.duration,
  });

  bool get _isOnline => connectionMode == ConnectionMode.online;

  String get _resultLabel => switch (result) {
    POVResult.win => _isOnline ? 'You won!' : 'White wins!',
    POVResult.lose => _isOnline ? 'You lost.' : 'Black wins!',
    POVResult.draw => 'Draw.',
    POVResult.ongoing => '',
  };

  String get _resultIcon => switch (result) {
    POVResult.win => '♛',
    POVResult.lose => '♟',
    POVResult.draw => '½',
    POVResult.ongoing => '',
  };

  String get _endReasonLabel => switch (matchResult) {
    MatchResult.checkmate => 'Checkmate',
    MatchResult.resignation => 'Resignation',
    MatchResult.timeout => 'Timeout',
    MatchResult.draw => 'Draw agreed',
  };

  Color _iconBackground(ColorScheme cs) => switch (result) {
    POVResult.win => cs.primaryContainer,
    POVResult.lose => cs.errorContainer,
    POVResult.draw => cs.surfaceContainerHighest,
    POVResult.ongoing => cs.surfaceContainerHighest,
  };

  ({String white, String black}) get _scores => switch (result) {
    POVResult.win => (white: '1', black: '0'),
    POVResult.lose => (white: '0', black: '1'),
    POVResult.draw => (white: '½', black: '½'),
    POVResult.ongoing => (white: '-', black: '-'),
  };

  Color _whiteScoreColor(ColorScheme cs) => switch (result) {
    POVResult.win => cs.primary,
    POVResult.lose => cs.error,
    _ => cs.onSurfaceVariant,
  };

  Color _blackScoreColor(ColorScheme cs) => switch (result) {
    POVResult.win => cs.error,
    POVResult.lose => cs.primary,
    _ => cs.onSurfaceVariant,
  };

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final scores = _scores;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: _iconBackground(cs),
                    child: Text(
                      _resultIcon,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(_resultLabel, style: tt.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    '$_endReasonLabel · Move $moveCount',
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Players row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  _PlayerColumn(
                    name: whitePlayerName,
                    side: 'White',
                    isWhite: true,
                    score: scores.white,
                    scoreColor: _whiteScoreColor(cs),
                  ),
                  Expanded(
                    child: Text(
                      'vs',
                      textAlign: TextAlign.center,
                      style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                  _PlayerColumn(
                    name: blackPlayerName,
                    side: 'Black',
                    isWhite: false,
                    score: scores.black,
                    scoreColor: _blackScoreColor(cs),
                    alignRight: true,
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Stats
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  _StatCell(value: '$moveCount', label: 'Moves'),
                  _StatCell(
                    value: duration.toFormattedString(),
                    label: 'Duration',
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Actions
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: SecondaryNavButton(
                      label: "Main menu",
                      labelStyle: context.mainTextStyle(),
                      onPressed: () {
                        context.pop();
                        context.go("/");
                      },
                    ),
                  ),

                  const SizedBox(width: 8),

                  // TODO: implement rematch and replay
                  Expanded(
                    child: PrimaryNavButton(
                      label: _isOnline ? 'Rematch' : 'Play again',
                      labelStyle: context.mainTextStyle(),
                      onPressed: () => context.pop(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Private sub-widgets unchanged from before
class _PlayerColumn extends StatelessWidget {
  final String name;
  final String side;
  final bool isWhite;
  final String score;
  final Color scoreColor;
  final bool alignRight;

  const _PlayerColumn({
    required this.name,
    required this.side,
    required this.isWhite,
    required this.score,
    required this.scoreColor,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final sideIndicator = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (alignRight) ...[
          Text(side, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
          const SizedBox(width: 4),
        ],
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isWhite ? Colors.white : Colors.black,
            border: Border.all(color: cs.outlineVariant),
          ),
        ),
        if (!alignRight) ...[
          const SizedBox(width: 4),
          Text(side, style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
        ],
      ],
    );

    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(name, style: tt.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        sideIndicator,
        const SizedBox(height: 6),
        Text(
          score,
          style: tt.headlineSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: scoreColor,
          ),
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;

  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: tt.titleMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
