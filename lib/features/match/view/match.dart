import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/styles/text.dart';
import 'package:chess_app/core/styles/theme.dart';
import 'package:chess_app/core/widgets/animation_wrapper/swiping_shader.dart';
import 'package:chess_app/core/widgets/custom_buttons.dart';
import 'package:chess_app/core/widgets/player_card.dart';
import 'package:chess_app/features/chess_board/view/chess_board.dart';
import 'package:chess_app/features/match/view/match_end.dart';
import 'package:chess_app/features/match/viewmodel/match_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class Match extends StatelessWidget {
  final bool enableBot;
  const Match({super.key, this.enableBot = false});

  @override
  Widget build(BuildContext context) {
    final MatchViewmodel matchViewmodel = Provider.of<MatchViewmodel>(
      context,
      listen: false,
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.symmetric(
          vertical: AppTheme.spaceS,
          horizontal: AppTheme.spaceS,
        ),
        child: Stack(
          children: [
            Selector<MatchViewmodel, GameResultType>(
              selector: (context, viewmodel) => viewmodel.result,
              builder: (context, result, child) {
                if (result != GameResultType.ongoing) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    MatchEndDialog.show(context, result);
                  });
                }
                return const SizedBox.shrink();
              },
            ),

            // ── Main layout ──
            _MatchLayout(enableBot: enableBot, matchViewmodel: matchViewmodel),

            Align(alignment: Alignment.topRight, child: _Menu()),
            enableBot
                ? Align(
                    alignment: Alignment.bottomLeft,
                    child: BarButton(
                      icon: Icons.redo_sharp,
                      label: 'Undo',
                      tooltip: 'Undo last move',
                      onPressed: () => matchViewmodel.relayUnMakeSignal(),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}

class _MatchLayout extends StatelessWidget {
  final bool enableBot;
  final MatchViewmodel matchViewmodel;

  const _MatchLayout({required this.enableBot, required this.matchViewmodel});

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
                      playerName: enableBot ? 'Bot · Easy' : 'Player 2',
                      playerSide: matchViewmodel.playerTwoSide,
                      isPlayerOne: false,
                      isBot: enableBot,
                    ),
                  ),

                  SizedBox(
                    height: stripHeight,
                    child: _TurnStrip(targetSide: matchViewmodel.playerTwoSide),
                  ),

                  ChessBoard(enableBot: enableBot),

                  SizedBox(
                    height: stripHeight,
                    child: _TurnStrip(targetSide: matchViewmodel.playerOneSide),
                  ),

                  SizedBox(
                    height: cardHeight,
                    child: PlayerCard(
                      playerName: 'You',
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
                FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    targetSide == 'white' ? 'Your turn' : "Opponent's turn",
                    style: context.turnStripText(),
                  ),
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

class _MovesSidebar extends StatefulWidget {
  final double? maxPanelWidth;

  const _MovesSidebar({this.maxPanelWidth});

  @override
  State<_MovesSidebar> createState() => _MovesSidebarState();
}

class _MovesSidebarState extends State<_MovesSidebar> {
  bool _isOpen = false;

  void _toggle() => setState(() => _isOpen = !_isOpen);

  @override
  Widget build(BuildContext context) {
    return Row(
      // Ensure the sidebar takes full height if isVertical is true
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Toggle Button ──
        GestureDetector(
          onTap: _toggle,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: AppCustomColors.surface,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _isOpen ? AppCustomColors.dark : AppCustomColors.border,
                width: _isOpen ? 1.5 : 1.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              spacing: 8,
              children: [
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 260),
                  child: const Icon(Icons.chevron_right_rounded, size: 18),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: const Text(
                    'MOVES',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
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
                      color: AppCustomColors.dark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: AppCustomColors.surface,
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          // If maxPanelWidth is null, it expands to available space (infinity)
          width: _isOpen
              ? (widget.maxPanelWidth ?? context.screenWidth / 2)
              : 0,
          child: ClipRect(
            child: const Padding(
              padding: EdgeInsets.only(left: 8),
              child: _MoveHistoryPanel(),
            ),
          ),
        ),
      ],
    );
  }
}

class _MoveHistoryPanel extends StatelessWidget {
  const _MoveHistoryPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppCustomColors.surface,
        borderRadius: BorderRadius.circular(4),
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
                        borderRadius: BorderRadius.circular(4),
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

class _Menu extends StatefulWidget {
  const _Menu();

  @override
  State<_Menu> createState() => _MenuState();
}

class _MenuState extends State<_Menu> {
  bool _isOpen = false;

  void _openMenu() {
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: BarButton(
              icon: Icons.menu,
              label: "Menu",
              tooltip: "Open menu",
              onPressed: _openMenu,
            ),
          ),
          AnimatedSize(
            duration: Duration(milliseconds: 200),
            child: _isOpen
                ? ClipRect(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BarButton(
                          svgPath: 'assets/icons/home.svg',
                          label: 'Home',
                          tooltip: 'Back to home',
                          onPressed: () => context.go('/'),
                        ),
                        BarButton(
                          svgPath: 'assets/icons/resign.svg',
                          label: 'Resign',
                          tooltip: 'Resign the game',
                          onPressed: () {},
                          isDanger: true,
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
