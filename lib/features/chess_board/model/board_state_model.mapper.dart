// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'board_state_model.dart';

class BoardStateMapper extends ClassMapperBase<BoardState> {
  BoardStateMapper._();

  static BoardStateMapper? _instance;
  static BoardStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BoardStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'BoardState';

  static bool _$isPromotion(BoardState v) => v.isPromotion;
  static const Field<BoardState, bool> _f$isPromotion = Field(
    'isPromotion',
    _$isPromotion,
    opt: true,
    def: false,
  );
  static List<String> _$pieceKeys(BoardState v) => v.pieceKeys;
  static const Field<BoardState, List<String>> _f$pieceKeys = Field(
    'pieceKeys',
    _$pieceKeys,
    opt: true,
  );
  static Sides _$activeSide(BoardState v) => v.activeSide;
  static const Field<BoardState, Sides> _f$activeSide = Field(
    'activeSide',
    _$activeSide,
  );
  static Map<String, PieceModel> _$pieceList(BoardState v) => v.pieceList;
  static const Field<BoardState, Map<String, PieceModel>> _f$pieceList = Field(
    'pieceList',
    _$pieceList,
  );
  static List<int> _$moveList(BoardState v) => v.moveList;
  static const Field<BoardState, List<int>> _f$moveList = Field(
    'moveList',
    _$moveList,
    opt: true,
  );
  static String? _$selectedPieceKey(BoardState v) => v.selectedPieceKey;
  static const Field<BoardState, String> _f$selectedPieceKey = Field(
    'selectedPieceKey',
    _$selectedPieceKey,
    opt: true,
  );
  static int? _$preFrom(BoardState v) => v.preFrom;
  static const Field<BoardState, int> _f$preFrom = Field(
    'preFrom',
    _$preFrom,
    opt: true,
  );
  static int? _$from(BoardState v) => v.from;
  static const Field<BoardState, int> _f$from = Field(
    'from',
    _$from,
    opt: true,
  );
  static int? _$to(BoardState v) => v.to;
  static const Field<BoardState, int> _f$to = Field('to', _$to, opt: true);
  static int? _$checkedKingSquare(BoardState v) => v.checkedKingSquare;
  static const Field<BoardState, int> _f$checkedKingSquare = Field(
    'checkedKingSquare',
    _$checkedKingSquare,
    opt: true,
  );
  static int? _$promoteSquareIndex(BoardState v) => v.promoteSquareIndex;
  static const Field<BoardState, int> _f$promoteSquareIndex = Field(
    'promoteSquareIndex',
    _$promoteSquareIndex,
    opt: true,
  );

  @override
  final MappableFields<BoardState> fields = const {
    #isPromotion: _f$isPromotion,
    #pieceKeys: _f$pieceKeys,
    #activeSide: _f$activeSide,
    #pieceList: _f$pieceList,
    #moveList: _f$moveList,
    #selectedPieceKey: _f$selectedPieceKey,
    #preFrom: _f$preFrom,
    #from: _f$from,
    #to: _f$to,
    #checkedKingSquare: _f$checkedKingSquare,
    #promoteSquareIndex: _f$promoteSquareIndex,
  };

  static BoardState _instantiate(DecodingData data) {
    return BoardState(
      isPromotion: data.dec(_f$isPromotion),
      pieceKeys: data.dec(_f$pieceKeys),
      activeSide: data.dec(_f$activeSide),
      pieceList: data.dec(_f$pieceList),
      moveList: data.dec(_f$moveList),
      selectedPieceKey: data.dec(_f$selectedPieceKey),
      preFrom: data.dec(_f$preFrom),
      from: data.dec(_f$from),
      to: data.dec(_f$to),
      checkedKingSquare: data.dec(_f$checkedKingSquare),
      promoteSquareIndex: data.dec(_f$promoteSquareIndex),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static BoardState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<BoardState>(map);
  }

  static BoardState fromJson(String json) {
    return ensureInitialized().decodeJson<BoardState>(json);
  }
}

mixin BoardStateMappable {
  String toJson() {
    return BoardStateMapper.ensureInitialized().encodeJson<BoardState>(
      this as BoardState,
    );
  }

  Map<String, dynamic> toMap() {
    return BoardStateMapper.ensureInitialized().encodeMap<BoardState>(
      this as BoardState,
    );
  }

  BoardStateCopyWith<BoardState, BoardState, BoardState> get copyWith =>
      _BoardStateCopyWithImpl<BoardState, BoardState>(
        this as BoardState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return BoardStateMapper.ensureInitialized().stringifyValue(
      this as BoardState,
    );
  }

  @override
  bool operator ==(Object other) {
    return BoardStateMapper.ensureInitialized().equalsValue(
      this as BoardState,
      other,
    );
  }

  @override
  int get hashCode {
    return BoardStateMapper.ensureInitialized().hashValue(this as BoardState);
  }
}

extension BoardStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, BoardState, $Out> {
  BoardStateCopyWith<$R, BoardState, $Out> get $asBoardState =>
      $base.as((v, t, t2) => _BoardStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BoardStateCopyWith<$R, $In extends BoardState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pieceKeys;
  MapCopyWith<
    $R,
    String,
    PieceModel,
    ObjectCopyWith<$R, PieceModel, PieceModel>
  >
  get pieceList;
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get moveList;
  $R call({
    bool? isPromotion,
    List<String>? pieceKeys,
    Sides? activeSide,
    Map<String, PieceModel>? pieceList,
    List<int>? moveList,
    String? selectedPieceKey,
    int? preFrom,
    int? from,
    int? to,
    int? checkedKingSquare,
    int? promoteSquareIndex,
  });
  BoardStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BoardStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, BoardState, $Out>
    implements BoardStateCopyWith<$R, BoardState, $Out> {
  _BoardStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<BoardState> $mapper =
      BoardStateMapper.ensureInitialized();
  @override
  ListCopyWith<$R, String, ObjectCopyWith<$R, String, String>> get pieceKeys =>
      ListCopyWith(
        $value.pieceKeys,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(pieceKeys: v),
      );
  @override
  MapCopyWith<
    $R,
    String,
    PieceModel,
    ObjectCopyWith<$R, PieceModel, PieceModel>
  >
  get pieceList => MapCopyWith(
    $value.pieceList,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(pieceList: v),
  );
  @override
  ListCopyWith<$R, int, ObjectCopyWith<$R, int, int>> get moveList =>
      ListCopyWith(
        $value.moveList,
        (v, t) => ObjectCopyWith(v, $identity, t),
        (v) => call(moveList: v),
      );
  @override
  $R call({
    bool? isPromotion,
    Object? pieceKeys = $none,
    Sides? activeSide,
    Map<String, PieceModel>? pieceList,
    Object? moveList = $none,
    Object? selectedPieceKey = $none,
    Object? preFrom = $none,
    Object? from = $none,
    Object? to = $none,
    Object? checkedKingSquare = $none,
    Object? promoteSquareIndex = $none,
  }) => $apply(
    FieldCopyWithData({
      if (isPromotion != null) #isPromotion: isPromotion,
      if (pieceKeys != $none) #pieceKeys: pieceKeys,
      if (activeSide != null) #activeSide: activeSide,
      if (pieceList != null) #pieceList: pieceList,
      if (moveList != $none) #moveList: moveList,
      if (selectedPieceKey != $none) #selectedPieceKey: selectedPieceKey,
      if (preFrom != $none) #preFrom: preFrom,
      if (from != $none) #from: from,
      if (to != $none) #to: to,
      if (checkedKingSquare != $none) #checkedKingSquare: checkedKingSquare,
      if (promoteSquareIndex != $none) #promoteSquareIndex: promoteSquareIndex,
    }),
  );
  @override
  BoardState $make(CopyWithData data) => BoardState(
    isPromotion: data.get(#isPromotion, or: $value.isPromotion),
    pieceKeys: data.get(#pieceKeys, or: $value.pieceKeys),
    activeSide: data.get(#activeSide, or: $value.activeSide),
    pieceList: data.get(#pieceList, or: $value.pieceList),
    moveList: data.get(#moveList, or: $value.moveList),
    selectedPieceKey: data.get(#selectedPieceKey, or: $value.selectedPieceKey),
    preFrom: data.get(#preFrom, or: $value.preFrom),
    from: data.get(#from, or: $value.from),
    to: data.get(#to, or: $value.to),
    checkedKingSquare: data.get(
      #checkedKingSquare,
      or: $value.checkedKingSquare,
    ),
    promoteSquareIndex: data.get(
      #promoteSquareIndex,
      or: $value.promoteSquareIndex,
    ),
  );

  @override
  BoardStateCopyWith<$R2, BoardState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _BoardStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

