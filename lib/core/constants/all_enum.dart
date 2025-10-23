enum Sides { 
  // ignore: constant_identifier_names
  white(0), black(1), color_NB(2);

  final int value;
  const Sides(this.value);

  static final Map<int, Sides> _fromValue = {
    for (Sides side in values) side.value: side
  };

  static final Map<String, Sides> _fromName = {
    for (Sides side in values) side.name: side
  };

  static Sides? fromValue(int value) => _fromValue[value];

  static Sides? fromName(String name) => _fromName[name];
}

enum PieceTypes { 
  // ignore: constant_identifier_names
  pawn(0), knight(1), bishop(2), rook(3), queen(4), king(5), pieceType_NB(6);

  final int value;
  const PieceTypes(this.value);

  static final Map<int, PieceTypes> _fromValue = {
    for (PieceTypes piece in values) piece.value: piece
  };

  static PieceTypes? fromValue(int value) => _fromValue[value];
}

enum Squares {
  a1('a1'), b1('b1'), c1('c1'), d1('d1'), e1('e1'), f1('f1'), g1('g1'), h1('h1'),
  a2('a2'), b2('b2'), c2('c2'), d2('d2'), e2('e2'), f2('f2'), g2('g2'), h2('h2'),
  a3('a3'), b3('b3'), c3('c3'), d3('d3'), e3('e3'), f3('f3'), g3('g3'), h3('h3'),
  a4('a4'), b4('b4'), c4('c4'), d4('d4'), e4('e4'), f4('f4'), g4('g4'), h4('h4'),
  a5('a5'), b5('b5'), c5('c5'), d5('d5'), e5('e5'), f5('f5'), g5('g5'), h5('h5'),
  a6('a6'), b6('b6'), c6('c6'), d6('d6'), e6('e6'), f6('f6'), g6('g6'), h6('h6'),
  a7('a7'), b7('b7'), c7('c7'), d7('d7'), e7('e7'), f7('f7'), g7('g7'), h7('h7'),
  a8('a8'), b8('b8'), c8('c8'), d8('d8'), e8('e8'), f8('f8'), g8('g8'), h8('h8');

  final String notation;
  const Squares(this.notation);

  static final Map<String, Squares> _fromNotation = {
    for (Squares square in values) square.notation: square
  };

  static final Map<int, Squares> _fromIndex = {
    for (Squares square in values) square.index: square 
  };

  static Squares? fromNotation(String notation) => _fromNotation[notation];

  static Squares? fromIndex(int index) => _fromIndex[index];
}

enum MoveFlags {
  quietMove(0),
  doublePawnPush(1),
  kingCastle(2),
  queenCastle(3),
  capture(4),
  enPassant(5),
  promotion(8),
  promotionCapture(12);

  final int value;
  const MoveFlags(this.value);

  static final Map<int, MoveFlags> _fromValue = {
    for (MoveFlags moveFlag in values) moveFlag.value: moveFlag
  };

  static MoveFlags? fromValue(int value) => _fromValue[value];
}

enum SoundFXs {
  movePiece, capturePiece, castling
}

