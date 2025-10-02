// Define C struct in Dart
import 'dart:ffi';

final class MoveData extends Struct {
  @Int32()
  external int fromSquare;

  @Int32()
  external int toSquare;

  @Int32()
  external int piecePromotedTo;

  @Int32()
  external int moveType;

  @Int32()
  external int moveIndex;
}

final class MoveListResult extends Struct {
  external Pointer<MoveData> moves;

  @Int32()
  external int count;
}