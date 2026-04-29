extension DurationExtensions on Duration {
  String toFormattedString() {
    // format: MM:SS
    final num minutes = inMinutes.remainder(60);
    final num seconds = inSeconds.remainder(60);

    final String formattedMinutes = minutes.toString().padLeft(2, '0');
    final String formattedSeconds = seconds.toString().padLeft(2, '0');

    return "$formattedMinutes:$formattedSeconds";
  }
}
