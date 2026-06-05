import 'package:beatlio_v2/models/db_models/exercise_db_model.dart';
import 'package:beatlio_v2/models/db_models/serie_db_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SessionDbModel {
  @Id()
  int id = 0;

  final String name;
  final int restDuration; // in seconds

  @Unique()
  final String uid;

  final exercises = ToMany<ExerciseDbModel>();
  final series = ToMany<SerieDbModel>();

  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  SessionDbModel({
    required this.name,
    required this.restDuration,
    required this.uid,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}
