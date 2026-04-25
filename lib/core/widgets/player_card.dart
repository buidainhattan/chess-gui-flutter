import 'package:auto_size_text_plus/auto_size_text_plus.dart';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:chess_app/features/match/viewmodel/timer_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

// ── Player Card ───────────────────────────────────────────────────────────────
class PlayerCard extends StatelessWidget {
  final String playerName;
  final Sides playerSide;
  final bool isPlayerOne;
  final bool isBot;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerSide,
    required this.isPlayerOne,
    required this.isBot,
  });

  @override
  Widget build(BuildContext context) {
    final MatchViewmodel matchViewmodel = Provider.of<MatchViewmodel>(context);

    final bool isActive = playerSide == matchViewmodel.sideToMove;
    final Color background, border, text, containerBackground, containerText;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    if (playerSide == Sides.white) {
      background = colorScheme.primaryContainer;
      border = colorScheme.primary;
      text = colorScheme.onPrimaryContainer;
      containerBackground = colorScheme.primary;
      containerText = colorScheme.onPrimary;
    } else {
      background = colorScheme.primary;
      border = colorScheme.primaryContainer;
      text = colorScheme.onPrimary;
      containerBackground = colorScheme.primaryContainer;
      containerText = colorScheme.onPrimaryContainer;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double timerHeight = constraints.maxHeight * 0.5;

        return Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.02,
                vertical: constraints.maxHeight * 0.1,
              ),
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: border, width: isActive ? 1.5 : 1.0),
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  _PlayerAvatar(
                    isBot: isBot,
                    backgroundColor: background,
                    borderColor: border,
                    iconColor: text,
                  ),

                  const SizedBox(width: 10),

                  Selector<MatchViewmodel, List<PieceTypes>>(
                    selector: (context, matchViewmodel) => isPlayerOne
                        ? matchViewmodel.playerOnePieceCaptured
                        : matchViewmodel.playerTwoPieceCaptured,
                    builder: (context, piecesCaptured, child) {
                      return Expanded(
                        child: _PlayerIndentity(
                          name: playerName,
                          nameColor: text,
                          side: playerSide,
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: timerHeight,
                    child: _PlayerTimer(
                      isActive: isActive,
                      isPlayerOne: isPlayerOne,
                      textColor: containerText,
                      background: containerBackground,
                      borderColor: Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: isActive
                    ? colorScheme.onPrimary.withValues(alpha: 0.08)
                    : colorScheme.onSurface.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PlayerAvatar extends StatelessWidget {
  final bool isBot;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;

  const _PlayerAvatar({
    required this.isBot,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 3 / 4,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.5,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: isBot
                  ? Text(
                      '🤖',
                      style: TextStyle(fontSize: 100, color: iconColor),
                    )
                  : SvgPicture.asset(
                      "assets/images/chess_pieces/black/pawn.svg",
                      colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerIndentity extends StatelessWidget {
  final String name;
  final Color nameColor;
  final dynamic side;

  const _PlayerIndentity({
    required this.name,
    required this.nameColor,
    required this.side,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Row(
            children: [
              Selector<MatchViewmodel, bool>(
                selector: (context, matchViewmodel) =>
                    side == matchViewmodel.sideToMove,
                builder: (context, isActive, child) {
                  if (isActive) {
                    return Row(
                      children: [
                        FractionallySizedBox(
                          heightFactor: 0.25,
                          child: _PulsingDot(color: nameColor),
                        ),
                        const SizedBox(width: AppTheme.spaceXS),
                      ],
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
              AutoSizeText(
                name,
                style: context.playerNameText(nameColor),
                minFontSize: 10,
              ),
            ],
          ),
        ),
        Selector<MatchViewmodel, List<PieceTypes>>(
          selector: (context, matchViewmodel) =>
              side == matchViewmodel.playerOneSide
              ? matchViewmodel.playerOnePieceCaptured
              : matchViewmodel.playerTwoPieceCaptured,
          builder: (context, piecesCaptured, child) {
            if (piecesCaptured.isEmpty) {
              return const Spacer(flex: 1);
            }
            return Expanded(
              child: _CapturedPiecesDisplayer(
                side: side,
                piecesCaptured: piecesCaptured,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PlayerTimer extends StatelessWidget {
  final bool isActive;
  final bool isPlayerOne;
  final Color textColor;
  final Color background;
  final Color borderColor;

  const _PlayerTimer({
    required this.isActive,
    required this.isPlayerOne,
    required this.textColor,
    required this.background,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spaceS,
        vertical: AppTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Selector<TimerViewmodel, String>(
        selector: (context, timerViewmodel) => isPlayerOne
            ? timerViewmodel.playerOneTime
            : timerViewmodel.playerTwoTime,
        builder: (context, timerText, child) {
          final formattedTimerText = timerText.length > 5
              ? timerText.substring(0, 5)
              : timerText;

          return Center(
            child: AutoSizeText(
              formattedTimerText,
              maxLines: 1,
              style: context.timerText(textColor),
            ),
          );
        },
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}

class _CapturedPiecesDisplayer extends StatelessWidget {
  final Sides side;
  final List<PieceTypes> piecesCaptured;

  const _CapturedPiecesDisplayer({
    required this.side,
    required this.piecesCaptured,
  });

  String get capturedSide =>
      side == Sides.white ? Sides.black.name : Sides.white.name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        heightFactor: 0.7,
        child: Stack(
          children: piecesCaptured.asMap().entries.map((entry) {
            final int index = entry.key;
            final PieceTypes piece = entry.value;

            return Align(
              widthFactor: 0.5 + index * 0.8,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: SvgPicture.asset(
                  'assets/images/chess_pieces/$capturedSide/${piece.name}.svg',
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
