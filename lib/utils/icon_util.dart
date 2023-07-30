import 'package:canalendar/enumerations/session_type.dart';

final class IconUtil {
  static String getSessionTypeIconPath(SessionType type) {
    switch (type) {
      case SessionType.sticky:
        return 'assets/icons/sticky-hollow.svg';
      case SessionType.edible:
        return 'assets/icons/edibles-hollow.svg';
      case SessionType.bong:
        return 'assets/icons/bong-hollow.svg';
      default:
        return 'assets/icons/joint-hollow.svg';
    }
  }
}