class TimeSetting {
  final String label;
  final int minutes;
  final int increment;

  const TimeSetting(this.label, this.minutes, this.increment);

  Duration get timeDuration => Duration(minutes: minutes);
  Duration get incrementDuration => Duration(seconds: increment);
}
