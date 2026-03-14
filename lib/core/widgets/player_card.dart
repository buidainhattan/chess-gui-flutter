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
  final double pieceSize;
  final bool isBot;
  final double? height;

  const PlayerCard({
    super.key,
    required this.playerName,
    required this.playerSide,
    required this.isPlayerOne,
    required this.pieceSize,
    required this.isBot,
    this.height,
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
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          height: height,
          decoration: BoxDecoration(
            color: cardBackground,
            borderRadius: BorderRadius.circular(12),
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
                      isActive: isActive,
                      name: playerName,
                      nameColor: text,
                      side: playerSide,
                      pieceSize: pieceSize,
                      piecesCaptured: piecesCaptured,
                    ),
                  );
                },
              ),

              Selector<TimerViewmodel, String>(
                selector: (context, timerViewmodel) => isPlayerOne
                    ? timerViewmodel.playerOneTime
                    : timerViewmodel.playerTwoTime,
                builder: (context, timeString, child) {
                  return _PlayerTimer(
                    isActive: isActive,
                    timerText: timeString,
                    background: clockBackground,
                    activeColor: clockText,
                    inactiveColor: textDim,
                    borderColor: AppCustomColors.border,
                  );
                },
              ),
            ],
          ),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final size = constraints.maxHeight;
          return Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Center(
              child: Text(
                isBot ? '🤖' : '♟',
                style: TextStyle(fontSize: size * 0.45, color: iconColor),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PlayerIndentity extends StatelessWidget {
  final bool isActive;
  final String name;
  final Color nameColor;
  final dynamic side;
  final double pieceSize;
  final List<PieceTypes> piecesCaptured;

  const _PlayerIndentity({
    required this.isActive,
    required this.name,
    required this.nameColor,
    required this.side,
    required this.pieceSize,
    required this.piecesCaptured,
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: AppTheme.spaceS,
      children: [
        Flexible(
          child: Row(
            children: [
              if (isActive) ...[
                _PulsingDot(color: nameColor),
                const SizedBox(width: 5),
              ],
              AutoSizeText(name, style: context.playerNameText(nameColor), minFontSize: 10,),
            ],
          ),
        ),
        if (piecesCaptured.isEmpty)
          Flexible(child: SizedBox(height: pieceSize,))
        else
          Flexible(
            child: _CapturedPiecesDisplayer(
              side: side,
              piecesCaptured: piecesCaptured,
              pieceSize: pieceSize,
            ),
          ),
      ],
    );
  }
}

class _PlayerTimer extends StatelessWidget {
  final bool isActive;
  final String timerText;
  final Color background;
  final Color activeColor;
  final Color inactiveColor;
  final Color borderColor;

  const _PlayerTimer({
    required this.isActive,
    required this.timerText,
    required this.background,
    required this.activeColor,
    required this.inactiveColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final displayTime = timerText.length > 5
        ? timerText.substring(0, 5)
        : timerText;

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isActive ? background : borderColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: AutoSizeText(
          displayTime,
          style: context.timerText(isActive ? activeColor : inactiveColor),
        ),
      ),
    );
  }
}

// ── Pulsing Dot ───────────────────────────────────────────────────────────────

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _opacity = Tween(
      begin: 1.0,
      end: 0.3,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
      ),
    );
  }
}

// ── Captured Pieces ───────────────────────────────────────────────────────────

class _CapturedPiecesDisplayer extends StatelessWidget {
  final String side;
  final List<PieceTypes> piecesCaptured;
  final double pieceSize;

  const _CapturedPiecesDisplayer({
    required this.side,
    required this.piecesCaptured,
    required this.pieceSize,
  });

  String get capturedSide =>
      side == Sides.white.name ? Sides.black.name : Sides.white.name;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: pieceSize,
      child: Stack(
        children: piecesCaptured.asMap().entries.map((entry) {
          return Positioned(
            left: (pieceSize * entry.key) / 2,
            child: SvgPicture.asset(
              'assets/images/chess_pieces/$capturedSide/${entry.value.name}.svg',
              width: pieceSize,
            ),
          );
        }).toList(),
      ),
    );
  }
}
