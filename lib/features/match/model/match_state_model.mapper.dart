// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_state_model.dart';

class MatchStateMapper extends ClassMapperBase<MatchState> {
  MatchStateMapper._();

  static MatchStateMapper? _instance;
  static MatchStateMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchStateMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchState';

  static Sides _$activeSide(MatchState v) => v.activeSide;
  static const Field<MatchState, Sides> _f$activeSide = Field(
    'activeSide',
    _$activeSide,
  );
  static String _$castlingRight(MatchState v) => v.castlingRight;
  static const Field<MatchState, String> _f$castlingRight = Field(
    'castlingRight',
    _$castlingRight,
  );
  static Squares? _$enPassantSquare(MatchState v) => v.enPassantSquare;
  static const Field<MatchState, Squares> _f$enPassantSquare = Field(
    'enPassantSquare',
    _$enPassantSquare,
    opt: true,
  );
  static int _$halfMoveClock(MatchState v) => v.halfMoveClock;
  static const Field<MatchState, int> _f$halfMoveClock = Field(
    'halfMoveClock',
    _$halfMoveClock,
    opt: true,
    def: 0,
  );
  static int _$fullMoveNumber(MatchState v) => v.fullMoveNumber;
  static const Field<MatchState, int> _f$fullMoveNumber = Field(
    'fullMoveNumber',
    _$fullMoveNumber,
    opt: true,
    def: 0,
  );
  static Map<Sides, List<PieceTypes>> _$capturedPieces(MatchState v) =>
      v.capturedPieces;
  static const Field<MatchState, Map<Sides, List<PieceTypes>>>
  _f$capturedPieces = Field('capturedPieces', _$capturedPieces, opt: true);
  static bool _$isChecking(MatchState v) => v.isChecking;
  static const Field<MatchState, bool> _f$isChecking = Field(
    'isChecking',
    _$isChecking,
    opt: true,
    def: false,
  );
  static bool _$isCheckmate(MatchState v) => v.isCheckmate;
  static const Field<MatchState, bool> _f$isCheckmate = Field(
    'isCheckmate',
    _$isCheckmate,
    opt: true,
    def: false,
  );

  @override
  final MappableFields<MatchState> fields = const {
    #activeSide: _f$activeSide,
    #castlingRight: _f$castlingRight,
    #enPassantSquare: _f$enPassantSquare,
    #halfMoveClock: _f$halfMoveClock,
    #fullMoveNumber: _f$fullMoveNumber,
    #capturedPieces: _f$capturedPieces,
    #isChecking: _f$isChecking,
    #isCheckmate: _f$isCheckmate,
  };

  static MatchState _instantiate(DecodingData data) {
    return MatchState(
      activeSide: data.dec(_f$activeSide),
      castlingRight: data.dec(_f$castlingRight),
      enPassantSquare: data.dec(_f$enPassantSquare),
      halfMoveClock: data.dec(_f$halfMoveClock),
      fullMoveNumber: data.dec(_f$fullMoveNumber),
      capturedPieces: data.dec(_f$capturedPieces),
      isChecking: data.dec(_f$isChecking),
      isCheckmate: data.dec(_f$isCheckmate),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static MatchState fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchState>(map);
  }

  static MatchState fromJson(String json) {
    return ensureInitialized().decodeJson<MatchState>(json);
  }
}

mixin MatchStateMappable {
  String toJson() {
    return MatchStateMapper.ensureInitialized().encodeJson<MatchState>(
      this as MatchState,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchStateMapper.ensureInitialized().encodeMap<MatchState>(
      this as MatchState,
    );
  }

  MatchStateCopyWith<MatchState, MatchState, MatchState> get copyWith =>
      _MatchStateCopyWithImpl<MatchState, MatchState>(
        this as MatchState,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return MatchStateMapper.ensureInitialized().stringifyValue(
      this as MatchState,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchStateMapper.ensureInitialized().equalsValue(
      this as MatchState,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchStateMapper.ensureInitialized().hashValue(this as MatchState);
  }
}

extension MatchStateValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchState, $Out> {
  MatchStateCopyWith<$R, MatchState, $Out> get $asMatchState =>
      $base.as((v, t, t2) => _MatchStateCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchStateCopyWith<$R, $In extends MatchState, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<
    $R,
    Sides,
    List<PieceTypes>,
    ObjectCopyWith<$R, List<PieceTypes>, List<PieceTypes>>
  >
  get capturedPieces;
  $R call({
    Sides? activeSide,
    String? castlingRight,
    Squares? enPassantSquare,
    int? halfMoveClock,
    int? fullMoveNumber,
    Map<Sides, List<PieceTypes>>? capturedPieces,
    bool? isChecking,
    bool? isCheckmate,
  });
  MatchStateCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _MatchStateCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchState, $Out>
    implements MatchStateCopyWith<$R, MatchState, $Out> {
  _MatchStateCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchState> $mapper =
      MatchStateMapper.ensureInitialized();
  @override
  MapCopyWith<
    $R,
    Sides,
    List<PieceTypes>,
    ObjectCopyWith<$R, List<PieceTypes>, List<PieceTypes>>
  >
  get capturedPieces => MapCopyWith(
    $value.capturedPieces,
    (v, t) => ObjectCopyWith(v, $identity, t),
    (v) => call(capturedPieces: v),
  );
  @override
  $R call({
    Sides? activeSide,
    String? castlingRight,
    Object? enPassantSquare = $none,
    int? halfMoveClock,
    int? fullMoveNumber,
    Object? capturedPieces = $none,
    bool? isChecking,
    bool? isCheckmate,
  }) => $apply(
    FieldCopyWithData({
      if (activeSide != null) #activeSide: activeSide,
      if (castlingRight != null) #castlingRight: castlingRight,
      if (enPassantSquare != $none) #enPassantSquare: enPassantSquare,
      if (halfMoveClock != null) #halfMoveClock: halfMoveClock,
      if (fullMoveNumber != null) #fullMoveNumber: fullMoveNumber,
      if (capturedPieces != $none) #capturedPieces: capturedPieces,
      if (isChecking != null) #isChecking: isChecking,
      if (isCheckmate != null) #isCheckmate: isCheckmate,
    }),
  );
  @override
  MatchState $make(CopyWithData data) => MatchState(
    activeSide: data.get(#activeSide, or: $value.activeSide),
    castlingRight: data.get(#castlingRight, or: $value.castlingRight),
    enPassantSquare: data.get(#enPassantSquare, or: $value.enPassantSquare),
    halfMoveClock: data.get(#halfMoveClock, or: $value.halfMoveClock),
    fullMoveNumber: data.get(#fullMoveNumber, or: $value.fullMoveNumber),
    capturedPieces: data.get(#capturedPieces, or: $value.capturedPieces),
    isChecking: data.get(#isChecking, or: $value.isChecking),
    isCheckmate: data.get(#isCheckmate, or: $value.isCheckmate),
  );

  @override
  MatchStateCopyWith<$R2, MatchState, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchStateCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

