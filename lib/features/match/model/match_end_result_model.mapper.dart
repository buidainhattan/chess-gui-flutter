// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'match_end_result_model.dart';

class MatchEndResultMapper extends ClassMapperBase<MatchEndResult> {
  MatchEndResultMapper._();

  static MatchEndResultMapper? _instance;
  static MatchEndResultMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = MatchEndResultMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'MatchEndResult';

  static POVResult _$resultPOV(MatchEndResult v) => v.resultPOV;
  static const Field<MatchEndResult, POVResult> _f$resultPOV = Field(
    'resultPOV',
    _$resultPOV,
  );
  static MatchResult _$result(MatchEndResult v) => v.result;
  static const Field<MatchEndResult, MatchResult> _f$result = Field(
    'result',
    _$result,
  );

  @override
  final MappableFields<MatchEndResult> fields = const {
    #resultPOV: _f$resultPOV,
    #result: _f$result,
  };

  static MatchEndResult _instantiate(DecodingData data) {
    return MatchEndResult(data.dec(_f$resultPOV), data.dec(_f$result));
  }

  @override
  final Function instantiate = _instantiate;

  static MatchEndResult fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<MatchEndResult>(map);
  }

  static MatchEndResult fromJson(String json) {
    return ensureInitialized().decodeJson<MatchEndResult>(json);
  }
}

mixin MatchEndResultMappable {
  String toJson() {
    return MatchEndResultMapper.ensureInitialized().encodeJson<MatchEndResult>(
      this as MatchEndResult,
    );
  }

  Map<String, dynamic> toMap() {
    return MatchEndResultMapper.ensureInitialized().encodeMap<MatchEndResult>(
      this as MatchEndResult,
    );
  }

  MatchEndResultCopyWith<MatchEndResult, MatchEndResult, MatchEndResult>
  get copyWith => _MatchEndResultCopyWithImpl<MatchEndResult, MatchEndResult>(
    this as MatchEndResult,
    $identity,
    $identity,
  );
  @override
  String toString() {
    return MatchEndResultMapper.ensureInitialized().stringifyValue(
      this as MatchEndResult,
    );
  }

  @override
  bool operator ==(Object other) {
    return MatchEndResultMapper.ensureInitialized().equalsValue(
      this as MatchEndResult,
      other,
    );
  }

  @override
  int get hashCode {
    return MatchEndResultMapper.ensureInitialized().hashValue(
      this as MatchEndResult,
    );
  }
}

extension MatchEndResultValueCopy<$R, $Out>
    on ObjectCopyWith<$R, MatchEndResult, $Out> {
  MatchEndResultCopyWith<$R, MatchEndResult, $Out> get $asMatchEndResult =>
      $base.as((v, t, t2) => _MatchEndResultCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class MatchEndResultCopyWith<$R, $In extends MatchEndResult, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({POVResult? resultPOV, MatchResult? result});
  MatchEndResultCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _MatchEndResultCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, MatchEndResult, $Out>
    implements MatchEndResultCopyWith<$R, MatchEndResult, $Out> {
  _MatchEndResultCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<MatchEndResult> $mapper =
      MatchEndResultMapper.ensureInitialized();
  @override
  $R call({POVResult? resultPOV, MatchResult? result}) => $apply(
    FieldCopyWithData({
      if (resultPOV != null) #resultPOV: resultPOV,
      if (result != null) #result: result,
    }),
  );
  @override
  MatchEndResult $make(CopyWithData data) => MatchEndResult(
    data.get(#resultPOV, or: $value.resultPOV),
    data.get(#result, or: $value.result),
  );

  @override
  MatchEndResultCopyWith<$R2, MatchEndResult, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _MatchEndResultCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

