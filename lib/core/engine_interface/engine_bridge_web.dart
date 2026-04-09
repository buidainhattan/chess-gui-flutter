import 'dart:async';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'package:chess_app/core/constants/all_enum.dart';
import 'package:chess_app/core/engine_interface/engine_bridge_interface.dart';
import 'package:chess_app/features/chess_board/model/move_model.dart';
import 'package:web/web.dart' as web;

class EngineBridgeWeb implements EngineBridgeInterface {
  static final EngineBridgeWeb _instance = EngineBridgeWeb._internal();
  factory EngineBridgeWeb() => _instance;

  late final web.Worker _worker;
  final Map<int, Completer<dynamic>> _pending = {};
  int _nextId = 0;
  late final Future<void> _ready;

  EngineBridgeWeb._internal() {
    _worker = web.Worker("engine_worker.js".toJS);
    final readyCompleter = Completer<void>();
    _ready = readyCompleter.future;

    _worker.onmessage = (web.MessageEvent e) {
      final msg = e.data as JSObject;
      final type = (msg.getProperty('type'.toJS) as JSString).toDart;

      if (type == 'ready') {
        readyCompleter.complete();
        return;
      }

      final id = (msg.getProperty('id'.toJS) as JSNumber).toDartInt;
      final result = msg.getProperty('result'.toJS);
      _pending.remove(id)?.complete(result);
    }.toJS;
  }

  Future<T> _send<T>(String type, JSObject data) async {
    await _ready;
    final id = _nextId++;
    final completer = Completer<T>();
    _pending[id] = completer;

    final msg = JSObject();
    msg.setProperty('id'.toJS, id.toJS);
    msg.setProperty('type'.toJS, type.toJS);
    msg.setProperty('data'.toJS, data);
    _worker.postMessage(msg);

    return completer.future;
  }

  @override
  Future<void> loadFromFEN(String fen) async {
    final d = JSObject()..setProperty('fen'.toJS, fen.toJS);
    await _send<JSAny?>('setBoardFromFen', d);
  }

  @override
  Future<String> getSideToMove() async {
    final r = await _send<JSString>('getSideToMove', JSObject());
    return r.toDart;
  }

  @override
  Future<List<MoveModel>> getLegalMoves() async {
    final arr = await _send<JSArray<JSObject>>('getLegalMoves', JSObject());
    final dartList = arr.toDart;
    return dartList.map((e) => _toMoveModel(e)).toList();
  }

  @override
  void makeMove(int moveIndex) {
    final d = JSObject()..setProperty('moveIndex'.toJS, moveIndex.toJS);
    _send<JSAny?>('makeMove', d);
  }

  @override
  void unMakeMove() {
    _send<JSAny?>('unMakeMove', JSObject());
  }

  @override
  Future<MoveModel> getBestMove(int depth) async {
    final d = JSObject()..setProperty('depth'.toJS, depth.toJS);
    final r = await _send<JSObject>('getBestMove', d);
    return _toMoveModel(r);
  }

  @override
  Future<int> getKingSquare(Sides kingSide) async {
    final d = JSObject()..setProperty('side'.toJS, kingSide.value.toJS);
    final r = await _send<JSNumber>('getKingSquare', d);
    return r.toDartInt;
  }

  @override
  Future<bool> isKingInCheck(Sides kingSide) async {
    final d = JSObject()..setProperty('side'.toJS, kingSide.value.toJS);
    final r = await _send<JSBoolean>('isKingInCheck', d);
    return r.toDart;
  }

  @override
  Future<bool> isRepetition() async {
    final r = await _send<JSBoolean>('isRepetition', JSObject());
    return r.toDart;
  }

  @override
  Future<String> disambiguating(Sides sideToMove, int moveIndex) async {
    final d = JSObject()
      ..setProperty('sideToMove'.toJS, sideToMove.value.toJS)
      ..setProperty('moveIndex'.toJS, moveIndex.toJS);
    final r = await _send<JSString>('disambiguating', d);
    return r.toDart;
  }

  @override
  void dispose() {
    _worker.terminate();
    for (final c in _pending.values) {
      c.completeError(StateError('EngineBridgeWeb disposed'));
    }
    _pending.clear();
  }

  MoveModel _toMoveModel(JSObject obj) {
    int get(String key) => (obj.getProperty(key.toJS) as JSNumber).toDartInt;
    return MoveModel(
      from: get('fromSquare'),
      to: get('toSquare'),
      piecePromotedTo: PieceTypes.fromValue(get('piecePromoteTo')),
      moveFlag: MoveFlags.fromValue(get('moveType'))!,
      index: get('moveIndex'),
    );
  }
}

EngineBridgeInterface createEngineBridge() => EngineBridgeWeb();
