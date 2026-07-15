import 'package:beatlio_v2/models/db_models/user_db_model.dart';
import 'package:beatlio_v2/models/user.dart';
import 'package:beatlio_v2/objectbox.g.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class UserProvider extends ChangeNotifier {
  final Box<UserDbModel> _userBox;

  UserProvider(Store store) : _userBox = store.box<UserDbModel>() {
    loadUser();
  }
  User? _user;

  User? get user => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void saveUser(User user) {
    _userBox.removeAll();

    final userDbModel = UserDbModel(name: user.name);

    _userBox.put(userDbModel);

    _user = user;
    notifyListeners();
  }

  void loadUser() {
    final users = _userBox.getAll();

    if (users.isNotEmpty) {
      _user = User(name: users.first.name);
    }
  }
}
