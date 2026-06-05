class Exercise {
  final String name;
  final String? description;
  final int duration; // in seconds
  final int bpm; // beats per minute
  final String uid;

  final bool useGlobalBpm;
  final bool useGlobalDuration;

  Exercise({
    required this.name,
    required this.uid,
    this.description = '',
    required this.duration,
    required this.bpm,
    this.useGlobalBpm = false,
    this.useGlobalDuration = false,
  });

  @override
  String toString() {
    return 'Exercise{name: $name, description: $description, duration: $duration, bpm: $bpm}';
  }
}
