import 'package:objectbox/objectbox.dart';

@Entity()
class UserDbModel {
  @Id()
  int id = 0;

  final String name;

  UserDbModel({required this.name});
}
