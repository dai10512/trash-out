import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:trash_out/model/trash_info.dart';

import '../util/shared_key.dart';
import '../util/util.dart';

part 'trash_info_list_service.g.dart';

@riverpod
class TrashInfoListService extends _$TrashInfoListService {
  @override
  FutureOr<List<TrashInfo?>> build() => fetch();

  List<TrashInfo?>? get currentTrashInfoList => state.value;

  Future<List<TrashInfo?>> fetch() async {
    final trashDayListJsonStr = prefs!.getString(SharedKey.trashInfoList);
    if (trashDayListJsonStr == null) {
      return [];
    }

    final trashDayListDecodedJson = await fromJsonStr<List>(trashDayListJsonStr);
    final trashInfoList = trashDayListDecodedJson
        .map((e) => TrashInfo.fromJson(e))
        .cast<TrashInfo>()
        .toList();
    return trashInfoList;
  }

  Future<void> add(TrashInfo trashInfo) async {
    currentTrashInfoList!.add(trashInfo);
    final trashDayListJsonStr = await toJsonStr(currentTrashInfoList);
    prefs!.setString(SharedKey.trashInfoList, trashDayListJsonStr);
  }

  Future<void> delete(TrashInfo trashInfo) async {
    currentTrashInfoList!.remove(trashInfo);
    final trashDayListJsonStr = await toJsonStr(currentTrashInfoList);
    prefs!.setString(SharedKey.trashInfoList, trashDayListJsonStr);
  }

  Future<void> edit(TrashInfo trashInfo) async {
    currentTrashInfoList!.remove(trashInfo);
    final trashDayListJsonStr = await toJsonStr(currentTrashInfoList);
    prefs!.setString(SharedKey.trashInfoList, trashDayListJsonStr);
  }

  Future<String> toJsonStr(dynamic value) async {
    return jsonEncode(value).toString();
  }

  Future<T> fromJsonStr<T>(String? value) async {
    return jsonDecode(value ?? '') as T;
  }
}


