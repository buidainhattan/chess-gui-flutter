importScripts("ChessEngineWeb.js");

let _module = null;

ChessEngineModule().then((m) => {
  _module = m;
  postMessage({ type: "ready" });
});

// Same struct-reading helpers as before, now inside the worker
function readMoveData(ptr) {
  return {
    fromSquare: _module.getValue(ptr, "i32"),
    toSquare: _module.getValue(ptr + 4, "i32"),
    piecePromoteTo: _module.getValue(ptr + 8, "i32"),
    moveType: _module.getValue(ptr + 12, "i32"),
    moveIndex: _module.getValue(ptr + 16, "i32"),
  };
}

self.onmessage = function (e) {
  const { id, type, data } = e.data;
  let result = null;

  switch (type) {
    case "setBoardFromFen": {
      const stack = _module.stackSave();
      const ptr = _module.stringToUTF8OnStack(data.fen);
      _module._set_board_from_fen(ptr);
      _module.stackRestore(stack);
      break;
    }
    case "getSideToMove":
      result = _module.UTF8ToString(_module._get_side_to_move());
      break;
    case "getLegalMoves": {
      const resultPtr = _module._get_legal_moves();
      const movesPtr = _module.getValue(resultPtr, "i32");
      const count = _module.getValue(resultPtr + 4, "i32");
      const moves = [];
      for (let i = 0; i < count; i++) {
        moves.push(readMoveData(movesPtr + i * 20));
      }
      result = moves;
      break;
    }
    case "makeMove":
      _module._make_move(data.moveIndex);
      break;
    case "unMakeMove":
      _module._un_make_move();
      break;
    case "getBestMove": {
      // This is the blocking call — safe here in the worker
      const ptr = _module._get_best_move(data.depth);
      result = readMoveData(ptr);
      break;
    }
    case "getKingSquare":
      result = _module._get_king_square(data.side);
      break;
    case "isKingInCheck":
      result = _module._is_king_in_check(data.side) !== 0;
      break;
    case "isRepetition":
      result = _module._is_repetition() !== 0;
      break;
    case "disambiguating": {
      const stack = _module.stackSave();
      const ptr = _module._disambiguating(data.sideToMove, data.moveIndex);
      result = _module.UTF8ToString(ptr);
      _module.stackRestore(stack);
      break;
    }
  }

  postMessage({ id, type, result });
};
