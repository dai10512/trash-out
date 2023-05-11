import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trash_out/model/trash_info.dart';

part 'trash_info_list_service.g.dart';

@riverpod
class TrashInfoListService extends _$TrashInfoListService {
  @override
  FutureOr<List<TrashInfo?>?> build() => null;

  fetch() async {
    final prefs = await SharedPreferences.getInstance();
  }
}
