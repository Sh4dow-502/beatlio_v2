import 'package:beatlio_v2/models/db_models/serie_db_model.dart';
import 'package:beatlio_v2/models/db_models/session_db_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class ExerciseDbModel {
  @Id()
  int id = 0;

  @Unique()
  final String uid;
  final String name;
  final String? description;
  final int duration; // in seconds
  final int bpm; // beats per minute

  final bool useGlobalBpm;

  final bool useGlobalDuration;

  final session = ToOne<SessionDbModel>();
  final serie = ToOne<SerieDbModel>();

  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  ExerciseDbModel({
    required this.name,
    this.description = '',
    required this.duration,
    required this.bpm,
    required this.uid,
    this.useGlobalBpm = false,
    this.useGlobalDuration = false,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}
