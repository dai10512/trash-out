import 'package:uuid/uuid.dart';

// Util util = Util();

List<int> mapToList(Map map) {
  final List<int> keys = [];
  for (var i = 1; i <= map.length; i++) {
    if (map[i]) {
      keys.add(i);
    }
  }
  return keys;
}

final uuid = const Uuid();
