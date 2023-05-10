import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting.freezed.dart';

@freezed
abstract class Trash with _$Trash {
  const factory Trash({
    required NotificationDay notificationDay,
    @Default(12) int? hour,
    @Default(0) int? minute,
    @Default(false) bool doNotify,
  }) = _Trash;
}

enum NotificationDay {
  thatDay, //当日
  dayBefore, //前日
  ;
}
