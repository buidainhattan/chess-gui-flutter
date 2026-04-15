import 'package:dart_mappable/dart_mappable.dart';
part 'time_setting_model.mapper.dart';

@MappableClass()
class TimeSetting with TimeSettingMappable {
  final int minutes;
  final int increment;

  const TimeSetting(this.minutes, this.increment);

  Duration get timeDuration => Duration(minutes: minutes);
  Duration get incrementDuration => Duration(seconds: increment);
}
