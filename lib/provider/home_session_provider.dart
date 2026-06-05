import 'package:beatlio_v2/mappers/session_mapper.dart';
import 'package:beatlio_v2/models/session.dart';
import 'package:beatlio_v2/services/new_session_service.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class HomeSessionProvider extends ChangeNotifier {
  final NewSessionService _service;
  HomeSessionProvider(this._service);

  List<Session> _sessions = [];
  List<Session> get sessions => _sessions;

  Future<void> loadSessions() async {
    final dbSessions = await _service.getAllSessions();
    _sessions = dbSessions.map((e) => SessionMapper.toDomain(e)).toList();
    notifyListeners();
  }

  Future<void> deleteSession(String uid) async {
    await _service.deleteSession(uid);
    await loadSessions();
  }
}
