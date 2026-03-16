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
  final String playerSide;
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
    final bool isWhite = playerSide == Sides.white.name;
    final Color cardBackground,
        text,
        textDim,
        borderActive,
        avatarBackground,
        avatarBorder,
        clockBackground,
        clockText;
    if (isWhite) {
      cardBackground = clockText = AppCustomColors.surface;
      text = borderActive = clockBackground = AppCustomColors.dark;
      textDim = AppCustomColors.textDim;
      avatarBackground = AppCustomColors.border;
      avatarBorder = AppCustomColors.dark.withValues(alpha: 0.2);
    } else {
      cardBackground = clockText = AppCustomColors.dark;
      text = clockBackground = AppCustomColors.surface;
      textDim = AppCustomColors.surface.withValues(alpha: 0.55);
      borderActive = avatarBorder = AppCustomColors.border;
      avatarBackground = AppCustomColors.surface.withValues(alpha: 0.12);
    }

    return Selector<MatchViewmodel, bool>(
      selector: (context, matchViewmodel) =>
          matchViewmodel.sideToMove == playerSide,
      builder: (context, isActive, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth * 0.012,
                vertical: constraints.maxHeight * 0.08,
              ),
              decoration: BoxDecoration(
                color: cardBackground,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isActive ? borderActive : AppCustomColors.border,
                  width: isActive ? 1.5 : 1.0,
                ),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppCustomColors.dark.withValues(alpha: 0.12),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  _PlayerAvatar(
                    isBot: isBot,
                    backgroundColor: avatarBackground,
                    borderColor: avatarBorder,
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

                  FractionallySizedBox(
                    heightFactor: 0.6,
                    child: _PlayerTimer(
                      isActive: isActive,
                      isPlayerOne: isPlayerOne,
                      background: clockBackground,
                      activeColor: clockText,
                      inactiveColor: textDim,
                      borderColor: AppCustomColors.border,
                    ),
                  ),
                ],
              ),
            );
          },
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
              child: Text(
                isBot ? '🤖' : '♟',
                style: TextStyle(fontSize: 100, color: iconColor),
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
  final Color background;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;

  const _PlayerTimer({
    required this.isActive,
    required this.isPlayerOne,
    required this.background,
    required this.activeColor,
    required this.inactiveColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: Container(
        decoration: BoxDecoration(
          color: isActive ? background : borderColor,
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
                style: context.timerText(
                  isActive ? activeColor : inactiveColor,
                ),
              ),
            );
          },
        ),
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
  final String side;
  final List<PieceTypes> piecesCaptured;

  const _CapturedPiecesDisplayer({
    required this.side,
    required this.piecesCaptured,
  });

  String get capturedSide =>
      side == Sides.white.name ? Sides.black.name : Sides.white.name;

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
