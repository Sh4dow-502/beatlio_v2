String formatDuration(int seconds) {
  if (seconds < 60) {
    return '${seconds}s';
  }

  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int remainingSeconds = seconds % 60;

  final List<String> parts = [];

  if (hours > 0) {
    parts.add('${hours}h');
  }

  if (minutes > 0) {
    parts.add('$minutes min');
  }

  if (remainingSeconds > 0) {
    parts.add('${remainingSeconds}s');
  }

  return parts.join(' ');
}

String formatDurationWithoutPrefix(int seconds) {
  // if (seconds < 60) {
  //   return '$seconds';
  // }

  final int hours = seconds ~/ 3600;
  final int minutes = (seconds % 3600) ~/ 60;
  final int remainingSeconds = seconds % 60;

  final List<String> parts = [];

  if (hours > 0) {
    parts.add('$hours');
  }

  if (minutes > 0) {
    parts.add('$minutes');
  }

  if (remainingSeconds > 0) {
    parts.add('$remainingSeconds');
  }

  return parts.join(' ');
}

String formatSeconds(int seconds) {
  if (seconds < 60) {
    return '0:${seconds.toString().padLeft(2, '0')}';
  }

  return seconds.toString();
}
