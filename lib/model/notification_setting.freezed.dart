// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_setting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$Trash {
  NotificationDay get notificationDay => throw _privateConstructorUsedError;
  int? get hour => throw _privateConstructorUsedError;
  int? get minute => throw _privateConstructorUsedError;
  bool get doNotify => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrashCopyWith<Trash> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrashCopyWith<$Res> {
  factory $TrashCopyWith(Trash value, $Res Function(Trash) then) =
      _$TrashCopyWithImpl<$Res, Trash>;
  @useResult
  $Res call(
      {NotificationDay notificationDay, int? hour, int? minute, bool doNotify});
}

/// @nodoc
class _$TrashCopyWithImpl<$Res, $Val extends Trash>
    implements $TrashCopyWith<$Res> {
  _$TrashCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationDay = null,
    Object? hour = freezed,
    Object? minute = freezed,
    Object? doNotify = null,
  }) {
    return _then(_value.copyWith(
      notificationDay: null == notificationDay
          ? _value.notificationDay
          : notificationDay // ignore: cast_nullable_to_non_nullable
              as NotificationDay,
      hour: freezed == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int?,
      minute: freezed == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int?,
      doNotify: null == doNotify
          ? _value.doNotify
          : doNotify // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TrashCopyWith<$Res> implements $TrashCopyWith<$Res> {
  factory _$$_TrashCopyWith(_$_Trash value, $Res Function(_$_Trash) then) =
      __$$_TrashCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {NotificationDay notificationDay, int? hour, int? minute, bool doNotify});
}

/// @nodoc
class __$$_TrashCopyWithImpl<$Res> extends _$TrashCopyWithImpl<$Res, _$_Trash>
    implements _$$_TrashCopyWith<$Res> {
  __$$_TrashCopyWithImpl(_$_Trash _value, $Res Function(_$_Trash) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notificationDay = null,
    Object? hour = freezed,
    Object? minute = freezed,
    Object? doNotify = null,
  }) {
    return _then(_$_Trash(
      notificationDay: null == notificationDay
          ? _value.notificationDay
          : notificationDay // ignore: cast_nullable_to_non_nullable
              as NotificationDay,
      hour: freezed == hour
          ? _value.hour
          : hour // ignore: cast_nullable_to_non_nullable
              as int?,
      minute: freezed == minute
          ? _value.minute
          : minute // ignore: cast_nullable_to_non_nullable
              as int?,
      doNotify: null == doNotify
          ? _value.doNotify
          : doNotify // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$_Trash implements _Trash {
  const _$_Trash(
      {required this.notificationDay,
      this.hour = 12,
      this.minute = 0,
      this.doNotify = false});

  @override
  final NotificationDay notificationDay;
  @override
  @JsonKey()
  final int? hour;
  @override
  @JsonKey()
  final int? minute;
  @override
  @JsonKey()
  final bool doNotify;

  @override
  String toString() {
    return 'Trash(notificationDay: $notificationDay, hour: $hour, minute: $minute, doNotify: $doNotify)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Trash &&
            (identical(other.notificationDay, notificationDay) ||
                other.notificationDay == notificationDay) &&
            (identical(other.hour, hour) || other.hour == hour) &&
            (identical(other.minute, minute) || other.minute == minute) &&
            (identical(other.doNotify, doNotify) ||
                other.doNotify == doNotify));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, notificationDay, hour, minute, doNotify);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TrashCopyWith<_$_Trash> get copyWith =>
      __$$_TrashCopyWithImpl<_$_Trash>(this, _$identity);
}

abstract class _Trash implements Trash {
  const factory _Trash(
      {required final NotificationDay notificationDay,
      final int? hour,
      final int? minute,
      final bool doNotify}) = _$_Trash;

  @override
  NotificationDay get notificationDay;
  @override
  int? get hour;
  @override
  int? get minute;
  @override
  bool get doNotify;
  @override
  @JsonKey(ignore: true)
  _$$_TrashCopyWith<_$_Trash> get copyWith =>
      throw _privateConstructorUsedError;
}
