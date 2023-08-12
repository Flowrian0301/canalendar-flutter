import 'package:canalendar/enumerations/session_type.dart';
import 'package:canalendar/models/session.dart';

class Amounts {
  int _joints = 0;
  int _stickies = 0;
  int _edibles = 0;
  int _bongs = 0;

  int get joints => _joints;
  int get stickies => _stickies;
  int get edibles => _edibles;
  int get bongs => _bongs;

  Amounts();

  Amounts.fromIntegers(this._joints, this._stickies, this._edibles, this._bongs);

  Amounts.fromSessions(List<Session> sessions) {
    for (Session session in sessions) {
      switch (session.type) {
        case SessionType.joint:
          {
            _joints++;
            break;
          }
        case SessionType.sticky:
          {
            _stickies++;
            break;
          }
        case SessionType.edible:
          {
            _edibles++;
            break;
          }
        case SessionType.bong:
          {
            _bongs++;
            break;
          }
      }
    }
  }

  bool get isEmpty => joints == 0 && stickies == 0 && edibles == 0 && bongs == 0;
}