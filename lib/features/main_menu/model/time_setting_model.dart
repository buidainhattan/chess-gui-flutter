class TimeSetting {
  final int minutes;
  final int increment;

  const TimeSetting(this.minutes, this.increment);

  Duration get timeDuration => Duration(minutes: minutes);
  Duration get incrementDuration => Duration(seconds: increment);
}
