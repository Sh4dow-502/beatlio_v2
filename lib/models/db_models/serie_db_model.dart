import 'package:beatlio_v2/models/db_models/exercise_db_model.dart';
import 'package:beatlio_v2/models/db_models/session_db_model.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class SerieDbModel {
  @Id()
  int id = 0;

  final String name;
  final String? description;

  @Unique()
  final String uid;

  bool durationGlobal;
  bool bpmGlobal;

  int? durationValueGlobal;
  int? bpmValueGlobal;

  final exercises = ToMany<ExerciseDbModel>();
  final session = ToOne<SessionDbModel>();
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  SerieDbModel({
    required this.name,
    DateTime? lastUpdated,
    this.durationGlobal = true,
    this.bpmGlobal = true,
    this.durationValueGlobal,
    this.bpmValueGlobal,
    this.description = '',
    required this.uid,
  }) : lastUpdated = lastUpdated ?? DateTime.now();
}
