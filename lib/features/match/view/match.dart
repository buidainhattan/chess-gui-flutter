import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/animation_wrapper/hovering.dart';
import 'package:chess_app/core/widgets/animation_wrapper/sliding.dart';
import 'package:chess_app/core/widgets/animation_wrapper/swiping_shader.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/core/widgets/player_card.dart';
import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/view/match_end.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Match extends StatefulWidget {
  const Match({super.key});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  late final MatchViewmodel matchViewmodel;

  void _onMatchResultChanged() {
    if (matchViewmodel.result != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;

        MatchEndDialog.show(
          context,
          result: matchViewmodel.result!.resultPOV,
          matchResult: matchViewmodel.result!.result,
          connectionMode: ConnectionMode.offline,
          whitePlayerName: matchViewmodel.playerOneName,
          blackPlayerName: matchViewmodel.playerTwoName,
          moveCount: (matchViewmodel.algebraicHistory.length / 2).ceil(),
          duration: matchViewmodel.elapsedTime,
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    matchViewmodel = context.read<MatchViewmodel>();
    matchViewmodel.addListener(_onMatchResultChanged);
  }

  @override
  Widget build(BuildContext context) {
    final MatchViewmodel matchViewmodel = context.read<MatchViewmodel>();

    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(
              vertical: AppTheme.spaceS,
              horizontal: AppTheme.spaceS,
            ),
            child: Stack(
              children: [
                // ── Main layout ──
                _MatchLayout(matchViewmodel: matchViewmodel),

                matchViewmodel.botEnabled
                    ? Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: 100,
                          height: 50,
                          child: BarButton(
                            icon: Icons.redo_sharp,
                            label: 'Undo',
                            tooltip: 'Undo last move',
                            onPressed: () => matchViewmodel.relayUnMakeSignal(),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),

          Positioned.fill(left: 0, top: 0, bottom: 0, child: _MenuSidebar()),
        ],
      ),
    );
  }
}

class _MatchLayout extends StatelessWidget {
  final MatchViewmodel matchViewmodel;

  const _MatchLayout({required this.matchViewmodel});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const double columnSpacing = AppTheme.spaceXS;

        double stripHeight, cardHeight, occupiedVerticalSpace, boardWidth;

        stripHeight = constraints.maxHeight * 0.025;
        cardHeight = constraints.maxHeight * 0.1;

        if (context.isLandscape) {
          occupiedVerticalSpace =
              (cardHeight * 2) + (stripHeight * 2) + columnSpacing * 4;
          boardWidth = constraints.maxHeight - occupiedVerticalSpace;
        } else {
          boardWidth = constraints.maxWidth;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: boardWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                spacing: columnSpacing,
                children: [
                  SizedBox(
                    height: cardHeight,
                    child: PlayerCard(
                      playerName: matchViewmodel.playerTwoName,
                      playerSide: matchViewmodel.playerTwoSide,
                      isPlayerOne: false,
                      isBot: matchViewmodel.botEnabled,
                    ),
                  ),

                  SizedBox(
                    height: stripHeight,
                    child: _TurnStrip(
                      targetSide: matchViewmodel.playerTwoSide,
                      playerOneSide: matchViewmodel.playerOneSide,
                    ),
                  ),

                  ChessBoard(),

                  SizedBox(
                    height: stripHeight,
                    child: _TurnStrip(
                      targetSide: matchViewmodel.playerOneSide,
                      playerOneSide: matchViewmodel.playerOneSide,
                    ),
                  ),

                  SizedBox(
                    height: cardHeight,
                    child: PlayerCard(
                      playerName: matchViewmodel.playerOneName,
                      playerSide: matchViewmodel.playerOneSide,
                      isPlayerOne: true,
                      isBot: false,
                    ),
                  ),
                ],
              ),
            ),
            if (constraints.maxWidth > boardWidth * 2) ...[
              const SizedBox(width: AppTheme.spaceS),
              _MovesSidebar(maxPanelWidth: boardWidth),
            ],
          ],
        );
      },
    );
  }
}

class _TurnStrip extends StatelessWidget {
  final Sides targetSide;
  final Sides playerOneSide;
  const _TurnStrip({required this.targetSide, required this.playerOneSide});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Selector<MatchViewmodel, Sides>(
      selector: (context, matchViewmodel) => matchViewmodel.sideToMove,
      builder: (context, sideToMove, _) {
        final bool isActive = sideToMove == targetSide;

        return AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: SwipingShaderWrapper(
            activeColor: colorScheme.primary,
            inactiveColor: colorScheme.onPrimary,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceS),
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    sideToMove == playerOneSide
                        ? 'Your turn'
                        : "Opponent's turn",
                    style: context.turnStripText(),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceS),
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MovesSidebar extends StatefulWidget {
  final double? maxPanelWidth;

  const _MovesSidebar({this.maxPanelWidth});

  @override
  State<_MovesSidebar> createState() => _MovesSidebarState();
}

class _MovesSidebarState extends State<_MovesSidebar> {
  bool isOpen = false;

  void _toggle() => setState(() => isOpen = !isOpen);

  @override
  Widget build(BuildContext context) {
    final MatchViewmodel viewmodel = context.read<MatchViewmodel>();

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final bool isPlayerOneWhite = viewmodel.playerOneSide == Sides.white;
    final Color backgroundColor, borderColor, textColor;
    if (isPlayerOneWhite) {
      backgroundColor = colorScheme.primaryContainer;
      borderColor = colorScheme.primary;
      textColor = colorScheme.onPrimaryContainer;
    } else {
      backgroundColor = colorScheme.primary;
      borderColor = colorScheme.primaryContainer;
      textColor = colorScheme.onPrimary;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Toggle Button ──
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spaceS,
              vertical: AppTheme.spaceS * 1.5,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: borderColor, width: isOpen ? 1.5 : 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                AnimatedRotation(
                  turns: isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: textColor,
                  ),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    'MOVES',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: textColor,
                    ),
                  ),
                ),
                // Simplified Move Counter
                Selector<MatchViewmodel, int>(
                  selector: (_, vm) => vm.algebraicHistory.length,
                  builder: (_, count, _) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(
                        color: borderColor,
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        color: textColor,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Sliding history panel ──
        ClipRect(
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            alignment: Alignment.centerLeft,
            widthFactor: isOpen ? 1.0 : 0.0,
            child: SizedBox(
              width: widget.maxPanelWidth ?? context.screenWidth / 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _MoveHistoryPanel(
                  isPlayerOneWhite: isPlayerOneWhite,
                  backgroundColor: backgroundColor,
                  borderColor: borderColor,
                  textColor: textColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoveHistoryPanel extends StatelessWidget {
  final bool isPlayerOneWhite;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _MoveHistoryPanel({
    required this.isPlayerOneWhite,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color currentMoveHistory = isPlayerOneWhite
        ? colorScheme.primary.withValues(alpha: 0.25)
        : colorScheme.primaryContainer.withValues(alpha: 0.25);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
            child: Text(
              'MOVE HISTORY',
              style: TextStyle(
                color: textColor,
                fontSize: 10.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: borderColor),
          // List
          Expanded(
            child: Selector<MatchViewmodel, List<String>>(
              selector: (context, matchViewmodel) =>
                  matchViewmodel.algebraicHistory,
              builder: (context, history, _) {
                if (history.isEmpty) {
                  return Center(
                    child: Text(
                      'No moves yet',
                      style: TextStyle(color: textColor, fontSize: 13),
                    ),
                  );
                }

                final rowCount = (history.length / 2).ceil();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: rowCount,
                  itemBuilder: (_, i) {
                    final String white = history[i * 2];
                    final String? black = (i * 2 + 1 < history.length)
                        ? history[i * 2 + 1]
                        : null;
                    final bool isLast = i == rowCount - 1;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isLast ? currentMoveHistory : Colors.transparent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 26,
                            child: Text(
                              '${i + 1}.',
                              style: TextStyle(color: textColor, fontSize: 11),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              white,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 12,
                                fontWeight: isLast
                                    ? FontWeight.w700
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                          Expanded(
                            child: black != null
                                ? Text(
                                    black,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 12,
                                    ),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sidebar + Arrow Tab ──────────────────────────────────────────────────────
const double kArrowTabWidth = 48.0;
const Duration kSidebarDuration = Duration(milliseconds: 200);

class _MenuSidebar extends StatefulWidget {
  const _MenuSidebar();

  @override
  State<_MenuSidebar> createState() => _MenuSidebarState();
}

class _MenuSidebarState extends State<_MenuSidebar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: kSidebarDuration,
      value: 0.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _isOpen = !_isOpen);
    _isOpen ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Dim overlay ────────────────────────────────────────────────────
        AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            if (_controller.value == 0.0) return const SizedBox.shrink();
            return GestureDetector(
              onTap: _toggle,
              child: Container(
                color: Colors.black.withValues(alpha: _controller.value * 0.45),
              ),
            );
          },
        ),

        // ── Sidebar ────────────────────────────────────────────────────────
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SlidingWrapper(
              controller: _controller,
              direction: AxisDirection.right,
              child: IntrinsicWidth(
                child: _SidebarPanel(isOpen: _isOpen, onToggle: _toggle),
              ),
            ),
            // Arrow tab only visible when closed
            if (!_isOpen) _ArrowTab(onTap: _toggle),
          ],
        ),
      ],
    );
  }
}

// ─── Panel content ────────────────────────────────────────────────────────────

class _SidebarPanel extends StatelessWidget {
  const _SidebarPanel({required this.isOpen, required this.onToggle});

  final bool isOpen;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return Container(
      color: color.surfaceContainerHigh,
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            HoveringWrapper(
              child: _SidebarButton(
                icon: Icons.settings_outlined,
                label: 'Settings',
                onPressed: () {},
              ),
            ),
            HoveringWrapper(
              child: _SidebarButton(
                icon: Icons.home_outlined,
                label: 'Main Menu',
                onPressed: () => context.go('/'),
              ),
            ),
            const Spacer(),
            const Divider(height: 1, thickness: 1),
            HoveringWrapper(
              child: _SidebarButton(
                icon: Icons.chevron_left,
                label: 'Close',
                onPressed: onToggle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SidebarButton extends StatelessWidget {
  const _SidebarButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color.onSurface.withValues(alpha: 0.75),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: color.onSurface.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Arrow tab ────────────────────────────────────────────────────────────────

class _ArrowTab extends StatelessWidget {
  const _ArrowTab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return HoveringWrapper(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: kArrowTabWidth,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.chevron_right,
                size: 18,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              SizedBox(height: AppTheme.spaceM),
              RotatedBox(quarterTurns: 3, child: Text("Open menu")),
              SizedBox(height: AppTheme.spaceM),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
