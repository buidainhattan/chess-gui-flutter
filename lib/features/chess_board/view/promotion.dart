// promotion_overlay.dart
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/widgets/animation_wrapper/hovering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_svg/flutter_svg.dart';

@Preview(name: "promotion overlay")
Widget promotionPreview() {
  return Stack(
    children: [
      Positioned.fill(
        child: PromotionOverlay(
          sideToMove: Sides.white,
          file: 0,
          isPOVPromote: true,
          boardSize: 350,
          onPieceSelected: (piece) {},
        ),
      ),
    ],
  );
}

final List<PieceTypes> _promotionPieces = PieceTypes.promotionPieces();

class PromotionOverlay extends StatelessWidget {
  final Sides sideToMove;
  final int file; // 0–7, the column the pawn promoted on
  final bool isPOVPromote;
  final double boardSize;
  final ValueChanged<PieceTypes> onPieceSelected;

  const PromotionOverlay({
    super.key,
    required this.sideToMove,
    required this.file,
    required this.isPOVPromote,
    required this.boardSize,
    required this.onPieceSelected,
  });

  @override
  Widget build(BuildContext context) {
    final double squareSize = boardSize / 8;
    final double pickerWidth = squareSize * 4;

    // Clamp so picker never bleeds off the board edge
    final double rawLeft = (file * squareSize) - squareSize * 1.5;
    final double left = rawLeft.clamp(0.0, boardSize - pickerWidth);

    // Position overlay vertically to fit pov
    final double top = isPOVPromote ? squareSize : boardSize - (squareSize * 2);

    return Stack(
      children: [
        // Dim + input absorber
        Positioned.fill(
          child: Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: AbsorbPointer(),
          ),
        ),

        // Picker
        Positioned(
          left: left,
          top: top,
          child: _AnimatedPicker(
            sideToMove: sideToMove,
            squareSize: squareSize,
            file: file,
            povPromote: isPOVPromote,
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
  final bool povPromote; // true = rank 8 at top of screen
  final ValueSetter<PieceTypes> onPieceSelected;

  const _AnimatedPicker({
    required this.sideToMove,
    required this.squareSize,
    required this.file,
    required this.povPromote,
    required this.onPieceSelected,
  });

  @override
  State<_AnimatedPicker> createState() => _AnimatedPickerState();
}

class _AnimatedPickerState extends State<_AnimatedPicker>
    with TickerProviderStateMixin {
  late final AnimationController _scaleController;
  late final List<Animation<double>> _scalesIn;

  // Slide-out state
  PieceTypes? _selectedPiece;
  int? _selectedIndex;
  AnimationController? _slideController;
  Animation<Offset>? _slideAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _scalesIn = List.generate(_promotionPieces.length, (i) {
      final start = i * 0.05;
      return CurvedAnimation(
        parent: _scaleController,
        curve: Interval(start, start + 0.6, curve: Curves.easeOutBack),
      );
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController?.dispose();
    super.dispose();
  }

  void _onPieceTapped(PieceTypes piece, int index) async {
    if (_selectedPiece != null) return; // guard double-tap

    // offset accounts for position clamp near the board border
    final double offset;
    switch (widget.file) {
      case 0:
        offset = 0;
      case 1:
        offset = 1;
      case 6:
        offset = 2;
      case 7:
        offset = 3;
      default:
        offset = 1.5;
    }
    // horizontal slide toward promotion square
    final double dx = (offset - index) * widget.squareSize;

    // vertical slide toward promotion square
    // promotesAtTop → slide up (negative dy), else slide down (positive dy)
    final double dy = widget.povPromote
        ? -widget.squareSize.toDouble()
        : widget.squareSize.toDouble();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _slideAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: Offset(dx / widget.squareSize, dy / widget.squareSize),
        ).animate(
          CurvedAnimation(parent: _slideController!, curve: Curves.easeInBack),
        );

    setState(() {
      _selectedPiece = piece;
      _selectedIndex = index;
    });

    // let all animations finish before calling the selected callback
    await Future.wait([
      _scaleController.reverse(),
      _slideController!.forward(),
    ]);
    widget.onPieceSelected(piece);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_promotionPieces.length, (i) {
        final piece = _promotionPieces[i];
        final isSelected = _selectedIndex == i;

        Widget card = _PieceCard(
          pieceType: piece,
          sideToMove: widget.sideToMove,
          size: widget.squareSize,
          isSelected: isSelected,
          onTap: () => _onPieceTapped(piece, i),
        );

        // Slide the selected piece toward the promotion square
        if (isSelected && _slideAnimation != null) {
          card = SlideTransition(position: _slideAnimation!, child: card);
          return card;
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
  final bool isSelected;
  final VoidCallback onTap;

  const _PieceCard({
    required this.pieceType,
    required this.sideToMove,
    required this.size,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isWhite = sideToMove == Sides.white;

    final bg = isWhite ? colorScheme.primaryContainer : colorScheme.primary;
    final fg = isWhite ? colorScheme.onPrimaryContainer : colorScheme.onPrimary;

    return HoveringWrapper(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isSelected ? null : bg,
            border: isSelected
                ? null
                : Border.all(color: fg.withValues(alpha: 0.2), width: 0.5),
            boxShadow: isSelected
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          padding: EdgeInsets.all(size * 0.1),
          child: SvgPicture.asset(
            "assets/images/chess_pieces/${sideToMove.name}/${pieceType.name}.svg",
          ),
        ),
      ),
    );
  }
}
