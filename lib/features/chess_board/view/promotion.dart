// promotion_overlay.dart
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const _promotionPieces = [
  PieceTypes.queen,
  PieceTypes.rook,
  PieceTypes.bishop,
  PieceTypes.knight,
];

class PromotionOverlay extends StatelessWidget {
  final Sides sideToMove;
  final int file; // 0–7, the column the pawn promoted on
  final bool isBoardFlipped;
  final double boardSize;
  final ValueChanged<PieceTypes> onPieceSelected;

  const PromotionOverlay({
    super.key,
    required this.sideToMove,
    required this.file,
    required this.boardSize,
    required this.onPieceSelected,
    this.isBoardFlipped = false,
  });

  @override
  Widget build(BuildContext context) {
    final squareSize = boardSize / 8;
    final pickerWidth = squareSize * 4;

    // Clamp so picker never bleeds off the board edge
    final double rawLeft = (file * squareSize) - squareSize * 1.5;
    final double left = rawLeft.clamp(0.0, boardSize - pickerWidth);

    // White promotes at rank 8 — visually row 0 when not flipped
    // Show the picker coming down from the top edge
    final bool promotesAtTop = sideToMove == Sides.white
        ? !isBoardFlipped
        : isBoardFlipped;
    final double top = promotesAtTop ? 0.0 : boardSize - squareSize;

    return Stack(
      children: [
        // Dim + input absorber
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {}, // promotion is mandatory — block all taps
          ),
        ),
        ColoredBox(color: Colors.black.withValues(alpha: 0.3)),

        // Picker
        Positioned(
          left: left,
          top: top,
          child: _AnimatedPicker(
            sideToMove: sideToMove,
            squareSize: squareSize,
            file: file,
            promotesAtTop: promotesAtTop,
            onPieceSelected: onPieceSelected,
          ),
        ),
      ],
    );
  }
}

class _AnimatedPicker extends StatefulWidget {
  final Sides sideToMove;
  final double squareSize;
  final int file; // needed to compute slide target
  final bool promotesAtTop; // true = rank 8 at top of screen
  final ValueChanged<PieceTypes> onPieceSelected;

  const _AnimatedPicker({
    required this.sideToMove,
    required this.squareSize,
    required this.file,
    required this.promotesAtTop,
    required this.onPieceSelected,
  });

  @override
  State<_AnimatedPicker> createState() => _AnimatedPickerState();
}

class _AnimatedPickerState extends State<_AnimatedPicker>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<double>> _scalesIn;

  // Slide-out state
  PieceTypes? _selectedPiece;
  int? _selectedIndex;
  AnimationController? _slideController;
  Animation<Offset>? _slideAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    )..forward();

    _scalesIn = List.generate(_promotionPieces.length, (i) {
      final start = i * 0.07;
      return CurvedAnimation(
        parent: _controller,
        curve: Interval(start, start + 0.6, curve: Curves.easeOutBack),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _slideController?.dispose();
    super.dispose();
  }

  void _onPieceTapped(PieceTypes piece, int index) async {
    if (_selectedPiece != null) return; // guard double-tap

    // How far does the selected card need to slide to reach the promotion square?
    // The picker's left edge is at: file * squareSize - squareSize * 1.5
    // The selected card's left edge is at: pickerLeft + index * squareSize
    // The promotion square's left edge is at: file * squareSize
    // So horizontal delta = file * squareSize - (pickerLeft + index * squareSize)
    //                      = (1.5 - index) * squareSize
    final double dx = (1.5 - index) * widget.squareSize;

    // Vertical: slide toward the promotion rank edge
    // promotesAtTop → slide up (negative dy), else slide down (positive dy)
    final double dy = widget.promotesAtTop
        ? -widget.squareSize.toDouble()
        : widget.squareSize.toDouble();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    _slideAnim =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(
            dx / widget.squareSize,
            dy / widget.squareSize,
          ), // fractional for SlideTransition
        ).animate(
          CurvedAnimation(parent: _slideController!, curve: Curves.easeInBack),
        );

    setState(() {
      _selectedPiece = piece;
      _selectedIndex = index;
    });

    await _slideController!.forward();
    widget.onPieceSelected(piece); // fires completePromotion() after animation
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_promotionPieces.length, (i) {
        final piece = _promotionPieces[i];
        final isSelected = _selectedIndex == i;
        final isUnselected = _selectedPiece != null && !isSelected;

        Widget card = _PieceCard(
          pieceType: piece,
          sideToMove: widget.sideToMove,
          size: widget.squareSize,
          onTap: () => _onPieceTapped(piece, i),
        );

        // Fade out unselected pieces
        if (isUnselected) {
          card = AnimatedOpacity(
            opacity: 0.0,
            duration: const Duration(milliseconds: 120),
            child: card,
          );
        }

        // Slide the selected piece toward the promotion square
        if (isSelected && _slideAnim != null) {
          card = SlideTransition(position: _slideAnim!, child: card);
        }

        return ScaleTransition(scale: _scalesIn[i], child: card);
      }),
    );
  }
}

class _PieceCard extends StatelessWidget {
  final PieceTypes pieceType;
  final Sides sideToMove;
  final double size;
  final VoidCallback onTap;

  const _PieceCard({
    required this.pieceType,
    required this.sideToMove,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWhite = sideToMove == Sides.white;

    final bg = isWhite ? colorScheme.primaryContainer : colorScheme.primary;
    final fg = isWhite ? colorScheme.onPrimaryContainer : colorScheme.onPrimary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: fg.withValues(alpha: 0.2), width: 0.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(size * 0.1),
        child: SvgPicture.asset(
          // Same path convention as your existing PromotionDialog
          "assets/images/chess_pieces/${sideToMove.name}/${pieceType.name}.svg",
        ),
      ),
    );
  }
}
