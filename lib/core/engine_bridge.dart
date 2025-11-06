import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'package:chess_app/core/constants/all_enum.dart';
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
typedef DisambiguatingNative =
    Pointer<Utf8> Function(Int32 sideToMove, Int32 moveIndex);
typedef Disambiguating = Pointer<Utf8> Function(int sideToMove, int moveIndex);

// Typedefs for the C function that returns the move list struct
typedef GetLegalMovesNative = MoveListResult Function();
typedef GetLegalMoves = MoveListResult Function();

// Typedefs for the C function that returns the move data struct
typedef GetBestMoveNative = MoveData Function(Int32 depth);
typedef GetBestMove = MoveData Function(int depth);

class EngineBridge {
  late Isolate _engineIsolate;
  late SendPort _sendPort;
  final ReceivePort _receivePort = ReceivePort();
  bool _isStarted = false;
  Future<void>? _startFuture;

  static final EngineBridge _instance = EngineBridge.internal();

  factory EngineBridge() {
    return _instance;
  }

  EngineBridge.internal() {
    _startFuture = _startEngineIsolate();
  }

  void loadFromFEN(String fen) async {
    final Pointer<Utf8> stringPointer = fen.toNativeUtf8();
    try {
      await _send("setBoard", stringPointer);
    } finally {
      calloc.free(stringPointer);
    }
  }

  Future<String> getSideToMove() async {
    return await _send("getSideToMove", "") as String;
  }

  /// Gets all legal moves for the current board state.
  Future<List<MoveModel>> getLegalMoves() async {
    final MoveListResult result =
        await _send("getLegalMoves", "") as MoveListResult;
    final movesPtr = result.moves;
    final count = result.count;

    final moveList = <MoveModel>[];
    for (int i = 0; i < count; i++) {
      moveList.add(MoveModel.fromFFI(movesPtr[i]));
    }

    return moveList;
  }

  void makeMove(int moveIndex) async {
    await _send("makeMove", moveIndex);
  }

  void unMakeMove(int moveIndex) async {
    await _send("unMakeMove", moveIndex);
  }

  Future<MoveModel> getBestMove(int depth) async {
    final MoveData bestMove = await _send("getBestMove", depth) as MoveData;
    return MoveModel.fromFFI(bestMove);
  }

  Future<String> disambiguating(Sides sideToMove, int moveIndex) async {
    final Map<String, int> data = {
      'sideToMove': sideToMove.value,
      'moveIndex': moveIndex,
    };
    return await _send('disambiguating', data) as String;
  }

  // Clean up when done
  void dispose() {
    _engineIsolate.kill(); // Terminate the isolate
    _receivePort.close(); // Close our receive port
    _isStarted = false;
  }

  Future<void> _startEngineIsolate() async {
    if (_isStarted) return;

    _engineIsolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);
    _sendPort = await _receivePort.first;
    _isStarted = true;
  }

  static void _isolateEntry(SendPort mainSendPort) {
    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);

    // Determine the library path based on the OS
    late final String libraryPath;
    if (Platform.isWindows) {
      libraryPath = 'ChessEnginex64.dll';
    } else if (Platform.isLinux) {
      libraryPath = 'ChessEnginex64.so';
    } else if (Platform.isMacOS) {
      libraryPath = 'ChessEnginex64.dylib';
    } else {
      throw UnsupportedError('Unsupported platform');
    }

    // Load the dynamic library
    final DynamicLibrary dylib = DynamicLibrary.open(libraryPath);

    // Look up the C++ functions by name
    final SetBoard setBoard = dylib
        .lookup<NativeFunction<SetBoardNative>>('set_board_from_fen')
        .asFunction();
    final GetSideToMove getSideToMove = dylib
        .lookup<NativeFunction<GetSideToMove>>('get_side_to_move')
        .asFunction();
    final GetLegalMoves getLegalMoves = dylib
        .lookup<NativeFunction<GetLegalMovesNative>>('get_legal_moves')
        .asFunction<GetLegalMoves>();
    final MakeMove makeMove = dylib
        .lookup<NativeFunction<MakeMoveNative>>('make_move')
        .asFunction();
    final UnmakeMove unMakeMove = dylib
        .lookup<NativeFunction<UnmakeMoveNative>>('un_make_move')
        .asFunction();
    final GetBestMove getBestMove = dylib
        .lookup<NativeFunction<GetBestMoveNative>>('get_best_move')
        .asFunction();
    final Disambiguating disambiguating = dylib
        .lookup<NativeFunction<DisambiguatingNative>>('disambiguating')
        .asFunction();

    isolateReceivePort.listen((message) {
      final taskType = message['type'] as String;
      final data = message['data'];
      final replyPort = message['replyPort'] as SendPort;

      dynamic result;
      switch (taskType) {
        case 'setBoard':
          setBoard(data);
        case 'getSideToMove':
          result = getSideToMove().toDartString();
        case 'getLegalMoves':
          result = getLegalMoves();
        case 'makeMove':
          makeMove(data);
        case 'unMakeMove':
          unMakeMove(data);
        case 'getBestMove':
          result = getBestMove(data);
        case 'disambiguating':
          result = disambiguating(data['sideToMove'], data['moveIndex']).toDartString();
        default:
          result = {'error': 'Unknown task type'};
      }

      // Send result back using the replyPort included in the message
      replyPort.send(result);
    });
  }

  // Send work to the isolate and wait for result
  Future<dynamic> _send(String taskType, dynamic data) async {
    // Ensure isolate is ready before sending
    await _startFuture;

    // Create a one-time port to receive the reply for THIS specific request
    final replyPort = ReceivePort();

    // Send task type, data, and replyPort to the isolate
    _sendPort.send({
      'type': taskType,
      'data': data,
      'replyPort': replyPort.sendPort,
    });

    // Wait for and return the result
    return await replyPort.first;
  }
}
