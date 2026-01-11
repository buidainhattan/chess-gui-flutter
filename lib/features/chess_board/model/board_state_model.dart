import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/features/chess_board/model/piece_model.dart';
import 'package:dart_mappable/dart_mappable.dart';
part 'board_state_model.mapper.dart';

@MappableClass()
class BoardState with BoardStateMappable {
  // <--- GUI control variables --->
  // A bool value to control whether to display a promotion dialog or not
  final bool isPromotion;
  // List to hold address (key) of current piece on that square
  final List<String> pieceKeys;
  final Sides activeSide;
  // A map to access piece properties through key
  final Map<String, PieceModel>
  pieceList; // Moveable square indices of selected piece
  final List<int> moveList;
  final String? selectedPieceKey; // Store current selected piece key
  final int? preFrom; // The index which selected piece a turn before from
  final int? from; // The index which selected piece is on
  final int? to; // The index which seletected piece is about to move to
  final int? checkedKingSquare;
  final int? promoteSquareIndex;

  BoardState({
    this.isPromotion = false,
    List<String>? pieceKeys,
    required this.activeSide,
    required this.pieceList,
    List<int>? moveList,
    this.selectedPieceKey,
    this.preFrom,
    this.from,
    this.to,
    this.checkedKingSquare,
    this.promoteSquareIndex,
  }) : pieceKeys = pieceKeys ?? List.filled(64, "", growable: false),
       moveList = moveList ?? [];
}