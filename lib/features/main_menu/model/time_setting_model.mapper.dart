// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'time_setting_model.dart';

class TimeSettingMapper extends ClassMapperBase<TimeSetting> {
  TimeSettingMapper._();

  static TimeSettingMapper? _instance;
  static TimeSettingMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = TimeSettingMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'TimeSetting';

  static int _$minutes(TimeSetting v) => v.minutes;
  static const Field<TimeSetting, int> _f$minutes = Field('minutes', _$minutes);
  static int _$increment(TimeSetting v) => v.increment;
  static const Field<TimeSetting, int> _f$increment = Field(
    'increment',
    _$increment,
  );

  @override
  final MappableFields<TimeSetting> fields = const {
    #minutes: _f$minutes,
    #increment: _f$increment,
  };

  static TimeSetting _instantiate(DecodingData data) {
    return TimeSetting(data.dec(_f$minutes), data.dec(_f$increment));
  }

  @override
  final Function instantiate = _instantiate;

  static TimeSetting fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<TimeSetting>(map);
  }

  static TimeSetting fromJson(String json) {
    return ensureInitialized().decodeJson<TimeSetting>(json);
  }
}

mixin TimeSettingMappable {
  String toJson() {
    return TimeSettingMapper.ensureInitialized().encodeJson<TimeSetting>(
      this as TimeSetting,
    );
  }

  Map<String, dynamic> toMap() {
    return TimeSettingMapper.ensureInitialized().encodeMap<TimeSetting>(
      this as TimeSetting,
    );
  }

  TimeSettingCopyWith<TimeSetting, TimeSetting, TimeSetting> get copyWith =>
      _TimeSettingCopyWithImpl<TimeSetting, TimeSetting>(
        this as TimeSetting,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return TimeSettingMapper.ensureInitialized().stringifyValue(
      this as TimeSetting,
    );
  }

  @override
  bool operator ==(Object other) {
    return TimeSettingMapper.ensureInitialized().equalsValue(
      this as TimeSetting,
      other,
    );
  }

  @override
  int get hashCode {
    return TimeSettingMapper.ensureInitialized().hashValue(this as TimeSetting);
  }
}

extension TimeSettingValueCopy<$R, $Out>
    on ObjectCopyWith<$R, TimeSetting, $Out> {
  TimeSettingCopyWith<$R, TimeSetting, $Out> get $asTimeSetting =>
      $base.as((v, t, t2) => _TimeSettingCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class TimeSettingCopyWith<$R, $In extends TimeSetting, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? minutes, int? increment});
  TimeSettingCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _TimeSettingCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, TimeSetting, $Out>
    implements TimeSettingCopyWith<$R, TimeSetting, $Out> {
  _TimeSettingCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<TimeSetting> $mapper =
      TimeSettingMapper.ensureInitialized();
  @override
  $R call({int? minutes, int? increment}) => $apply(
    FieldCopyWithData({
      if (minutes != null) #minutes: minutes,
      if (increment != null) #increment: increment,
    }),
  );
  @override
  TimeSetting $make(CopyWithData data) => TimeSetting(
    data.get(#minutes, or: $value.minutes),
    data.get(#increment, or: $value.increment),
  );

  @override
  TimeSettingCopyWith<$R2, TimeSetting, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _TimeSettingCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

