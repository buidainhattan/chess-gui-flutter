import 'dart:ffi';
import 'dart:io';
import 'package:chess_app/core/constants/c_style_struct.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:ffi/ffi.dart';

// Typedefs for the C function that returns void
typedef SetBoardNative = Void Function(Pointer<Utf8>);
typedef SetBoard = void Function(Pointer<Utf8>);
typedef MakeMoveNative = Void Function(Int32 moveIndex);
typedef MakeMove = void Function(int moveIndex);
typedef UnmakeMoveNative = Void Function(Int32 moveIndex);
typedef UnmakeMove = void Function(int moveIndex);

// Typedefs for the C function that returns a string
typedef GetSideToMoveNative = Pointer<Utf8> Function();
typedef GetSideToMove = Pointer<Utf8> Function();

// Typedefs for the C function that returns the move list struct
typedef GetLegalMovesNative = MoveListResult Function();
typedef GetLegalMoves = MoveListResult Function();

class EngineBridge {
  late final DynamicLibrary _dylib;
  late final SetBoard _setBoard;
  late final GetSideToMove _getSideToMove;
  late final GetLegalMoves _getLegalMoves;
  late final MakeMove _makeMove;
  late final UnmakeMove _unMakeMove;

  static final EngineBridge _instance = EngineBridge.internal();

  factory EngineBridge() {
    return _instance;
  }

  EngineBridge.internal() {
    // Determine the library path based on the OS
    final String libraryPath;
    if (Platform.isWindows) {
      libraryPath = 'ChessEngineLite.dll';
    } else if (Platform.isLinux) {
      libraryPath = 'libmy_engine.so';
    } else if (Platform.isMacOS) {
      libraryPath = 'libmy_engine.dylib';
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    // Load the dynamic library
    _dylib = DynamicLibrary.open(libraryPath);

    // Look up the C++ functions by name
    _setBoard = _dylib
        .lookup<NativeFunction<SetBoardNative>>('set_board_from_fen')
        .asFunction();
    _getSideToMove = _dylib
        .lookup<NativeFunction<GetSideToMove>>('get_side_to_move')
        .asFunction();
    _getLegalMoves = _dylib
        .lookup<NativeFunction<GetLegalMovesNative>>('get_legal_moves')
        .asFunction<GetLegalMoves>();
    _makeMove = _dylib
        .lookup<NativeFunction<MakeMoveNative>>('make_move')
        .asFunction();
    _unMakeMove = _dylib
        .lookup<NativeFunction<UnmakeMoveNative>>('un_make_move')
        .asFunction();
  }

  void loadFromFEN(String fen) {
    _setBoard(fen.toNativeUtf8());
  }

  String getSideToMove() {
    return _getSideToMove().toDartString();
  }

  /// Gets all legal moves for the current board state.
  List<MoveModel> getLegalMoves() {
    final MoveListResult result = _getLegalMoves();
    final movesPtr = result.moves;
    final count = result.count;

    final moveList = <MoveModel>[];
    for (int i = 0; i < count; i++) {
      moveList.add(MoveModel.fromFFI(movesPtr[i]));
    }

    return moveList;
  }

  void makeMove(int moveIndex) {
    _makeMove(moveIndex);
  }

  void unMakeMove(int moveIndex) {
    _unMakeMove(moveIndex);
  }
}
