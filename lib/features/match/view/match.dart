import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/player_card.dart';
import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/view/match_end.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

// ── Match ─────────────────────────────────────────────────────────────────────

class Match extends StatelessWidget {
  final bool enableBot;
  const Match({super.key, this.enableBot = false});

  @override
  Widget build(BuildContext context) {
    final matchViewmodel = Provider.of<MatchViewmodel>(context, listen: false);

    return Scaffold(
      backgroundColor: AppCustomColors.background,
      bottomNavigationBar: _BottomBar(enableBot: enableBot),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Stack(
          children: [
            // Game-end listener
            Selector<MatchViewmodel, GameResultType>(
              selector: (context, viewmodel) => viewmodel.result,
              builder: (context, result, _) {
                if (result != GameResultType.ongoing) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    MatchEndDialog.show(context, result);
                  });
                }
                return const SizedBox.shrink();
              },
            ),

            // ── Main layout ──
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return _MatchLayout(
                  enableBot: enableBot,
                  matchViewmodel: matchViewmodel,
                  maxHeight: constraints.maxHeight,
                  maxWidth: constraints.maxWidth,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Match Layout ──────────────────────────────────────────────────────────────

class _MatchLayout extends StatelessWidget {
  final bool enableBot;
  final MatchViewmodel matchViewmodel;
  final double maxHeight;
  final double maxWidth;

  const _MatchLayout({
    required this.enableBot,
    required this.matchViewmodel,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    const double columnSpacing = AppTheme.spaceXS;
    final double stripHeight = maxHeight * 0.02;
    final double cardHeight = maxHeight * 0.1;

    final double totalSpacing = columnSpacing * 4;
    final double occupiedVerticalSpace =
        (cardHeight * 2) + (stripHeight * 2) + totalSpacing;

    final double boardWidth = maxHeight - occupiedVerticalSpace;

    return SizedBox(
      width: maxWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: boardWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: columnSpacing,
              children: [
                PlayerCard(
                  playerName: enableBot ? 'Bot · Easy' : 'Player 2',
                  playerSide: matchViewmodel.playerTwoSide,
                  isPlayerOne: false,
                  pieceSize: 24,
                  isBot: enableBot,
                  height: cardHeight,
                ),

                _TurnStrip(targetSide: matchViewmodel.playerTwoSide),
                        
                ChessBoard(enableBot: enableBot),
                        
                _TurnStrip(targetSide: matchViewmodel.playerOneSide),

                PlayerCard(
                  playerName: 'You',
                  playerSide: matchViewmodel.playerOneSide,
                  isPlayerOne: true,
                  pieceSize: 24,
                  isBot: false,
                  height: cardHeight,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppTheme.spaceM),
          _MovesSidebar(maxPanelWidth: boardWidth),
        ],
      ),
    );
  }
}

// ── Turn Strip ────────────────────────────────────────────────────────────────
// A slim animated bar that appears only when it's this side's turn.

class _TurnStrip extends StatelessWidget {
  final String targetSide;
  const _TurnStrip({required this.targetSide});

  @override
  Widget build(BuildContext context) {
    return Selector<MatchViewmodel, bool>(
      selector: (context, matchViewmodel) =>
          matchViewmodel.sideToMove == targetSide,
      builder: (context, isActive, _) {
        return AnimatedOpacity(
          opacity: isActive ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: SwipingShaderWrapper(
            activeColor: Colors.deepPurpleAccent,
            inactiveColor: AppCustomColors.border,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppCustomColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceS),
                Text(
                  targetSide == 'white' ? 'Your turn' : "Opponent's turn",
                  style: 
                   context.turnStripText(),
                ),
                const SizedBox(width: AppTheme.spaceS),
                Expanded(
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      color: AppCustomColors.border,
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

// ── Moves Sidebar ─────────────────────────────────────────────────────────────
// Persistent vertical tab to the right of the board. Tapping it slides the
// history panel open. Panel width is capped at [maxPanelWidth] (≤ board width)
// and fills all available space up to that cap.

class _MovesSidebar extends StatefulWidget {
  final double maxPanelWidth;
  const _MovesSidebar({required this.maxPanelWidth});

  @override
  State<_MovesSidebar> createState() => _MovesSidebarState();
}

class _MovesSidebarState extends State<_MovesSidebar> {
  static const double _tabWidth = 32;
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  @override
  Widget build(BuildContext context) {
    // Panel width = all remaining screen space after board + gap + tab,
    // but never wider than the board itself.

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Vertical tab (always visible, full column height) ──
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: _tabWidth,
            decoration: BoxDecoration(
              color: AppCustomColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isOpen ? AppCustomColors.dark : AppCustomColors.border,
                width: _isOpen ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppCustomColors.dark.withValues(alpha: 0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: _isOpen
                        ? AppCustomColors.dark
                        : AppCustomColors.textMid,
                  ),
                ),
                const SizedBox(height: 10),
                RotatedBox(
                  quarterTurns: 1,
                  child: Text(
                    'MOVES',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: _isOpen
                          ? AppCustomColors.dark
                          : AppCustomColors.textMid,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Selector<MatchViewmodel, int>(
                  selector: (context, matchViewmodel) =>
                      matchViewmodel.algebraicHistory.length,
                  builder: (context, count, widget) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppCustomColors.dark,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: AppCustomColors.surface,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Sliding history panel ──
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut, // Smoother than just .ease
          width: _isOpen ? widget.maxPanelWidth : 0,
          // This is the "Secret Sauce":
          child: ClipRect(
            // Prevents the child from "bleeding" out while narrow
            child: OverflowBox(
              // Allows the child to maintain its full width while being clipped
              minWidth: widget.maxPanelWidth,
              maxWidth: widget.maxPanelWidth,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: const _MoveHistoryPanel(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Move History Panel ────────────────────────────────────────────────────────

class _MoveHistoryPanel extends StatelessWidget {
  const _MoveHistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppCustomColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppCustomColors.border),
        boxShadow: [
          BoxShadow(
            color: AppCustomColors.dark.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
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
                color: AppCustomColors.textDim,
                fontSize: 10.5,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(height: 1, color: AppCustomColors.border),
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
                      style: TextStyle(
                        color: AppCustomColors.textDim,
                        fontSize: 13,
                      ),
                    ),
                  );
                }

                final rowCount = (history.length / 2).ceil();

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: rowCount,
                  itemBuilder: (_, i) {
                    final white = history[i * 2];
                    final black = (i * 2 + 1 < history.length)
                        ? history[i * 2 + 1]
                        : null;
                    final isLast = i == rowCount - 1;

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
                        color: isLast
                            ? AppCustomColors.activeBg
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 26,
                            child: Text(
                              '${i + 1}.',
                              style: TextStyle(
                                color: AppCustomColors.textDim,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              white,
                              style: TextStyle(
                                color: AppCustomColors.dark,
                                fontSize: 12,
                                fontWeight: isLast
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            child: black != null
                                ? Text(
                                    black,
                                    style: TextStyle(
                                      color: AppCustomColors.textMid,
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

class SwipingShaderWrapper extends StatefulWidget {
  final Widget child;
  final Color activeColor;
  final Color inactiveColor;
  final Duration duration;

  const SwipingShaderWrapper({
    super.key,
    required this.child,
    this.activeColor = Colors.blue,
    this.inactiveColor = const Color(0x33FFFFFF),
    this.duration = const Duration(milliseconds: 2000),
  });

  @override
  State<SwipingShaderWrapper> createState() => _SwipingShaderWrapperState();
}

class _SwipingShaderWrapperState extends State<SwipingShaderWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _tailAnimation;
  late final Animation<double> _headAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
    _tailAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
      ),
    );
    _headAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeInOut),
      ),
    );
  }

  @override
  void didUpdateWidget(SwipingShaderWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double tail = _tailAnimation.value;
        double head = _headAnimation.value;

        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                widget.inactiveColor,
                widget.activeColor,
                widget.activeColor,
                widget.inactiveColor,
              ],
              stops: [tail, tail, head, head],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

// ── Bottom Bar ────────────────────────────────────────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool enableBot;
  const _BottomBar({required this.enableBot});

  @override
  Widget build(BuildContext context) {
    final matchVm = Provider.of<MatchViewmodel>(context, listen: false);

    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: AppCustomColors.surface,
        border: Border(top: BorderSide(color: AppCustomColors.border)),
        boxShadow: [
          BoxShadow(
            color: AppCustomColors.dark.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ── Left: game actions ──
            Row(
              children: [
                _BarButton(
                  svgPath: 'assets/icons/redo.svg',
                  label: 'Undo',
                  tooltip: 'Undo last move',
                  onPressed: () => matchVm.relayUnMakeSignal(),
                ),
                const SizedBox(width: 8),
                _BarButton(
                  svgPath: 'assets/icons/resign.svg',
                  label: 'Resign',
                  tooltip: 'Resign the game',
                  onPressed: () {},
                  isDanger: true,
                ),
              ],
            ),
            // ── Right: app actions ──
            Row(
              children: [
                _BarButton(
                  svgPath: 'assets/icons/home.svg',
                  label: 'Home',
                  tooltip: 'Back to home',
                  onPressed: () => context.go('/'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Bar Button ────────────────────────────────────────────────────────────────

class _BarButton extends StatelessWidget {
  final String svgPath;
  final String label;
  final String tooltip;
  final VoidCallback onPressed;
  final bool isDanger;

  const _BarButton({
    required this.svgPath,
    required this.label,
    required this.tooltip,
    required this.onPressed,
    this.isDanger = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color fg = isDanger
        ? const Color(0xFFC0392B)
        : AppCustomColors.textMid;
    final Color hoverBg = isDanger
        ? const Color(0xFFFDF1F0)
        : AppCustomColors.activeBg;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(9),
        hoverColor: hoverBg,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppCustomColors.border),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                svgPath,
                width: 15,
                height: 15,
                colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
