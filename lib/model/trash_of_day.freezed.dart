// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trash_of_day.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

TrashOfDay _$TrashOfDayFromJson(Map<String, dynamic> json) {
  return _TrashOfDay.fromJson(json);
}

/// @nodoc
mixin _$TrashOfDay {
  TargetDay get targetDay => throw _privateConstructorUsedError;
  String get trashType => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TrashOfDayCopyWith<TrashOfDay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrashOfDayCopyWith<$Res> {
  factory $TrashOfDayCopyWith(
          TrashOfDay value, $Res Function(TrashOfDay) then) =
      _$TrashOfDayCopyWithImpl<$Res, TrashOfDay>;
  @useResult
  $Res call({TargetDay targetDay, String trashType});
}

/// @nodoc
class _$TrashOfDayCopyWithImpl<$Res, $Val extends TrashOfDay>
    implements $TrashOfDayCopyWith<$Res> {
  _$TrashOfDayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDay = null,
    Object? trashType = null,
  }) {
    return _then(_value.copyWith(
      targetDay: null == targetDay
          ? _value.targetDay
          : targetDay // ignore: cast_nullable_to_non_nullable
              as TargetDay,
      trashType: null == trashType
          ? _value.trashType
          : trashType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TrashOfDayCopyWith<$Res>
    implements $TrashOfDayCopyWith<$Res> {
  factory _$$_TrashOfDayCopyWith(
          _$_TrashOfDay value, $Res Function(_$_TrashOfDay) then) =
      __$$_TrashOfDayCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({TargetDay targetDay, String trashType});
}

/// @nodoc
class __$$_TrashOfDayCopyWithImpl<$Res>
    extends _$TrashOfDayCopyWithImpl<$Res, _$_TrashOfDay>
    implements _$$_TrashOfDayCopyWith<$Res> {
  __$$_TrashOfDayCopyWithImpl(
      _$_TrashOfDay _value, $Res Function(_$_TrashOfDay) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDay = null,
    Object? trashType = null,
  }) {
    return _then(_$_TrashOfDay(
      targetDay: null == targetDay
          ? _value.targetDay
          : targetDay // ignore: cast_nullable_to_non_nullable
              as TargetDay,
      trashType: null == trashType
          ? _value.trashType
          : trashType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_TrashOfDay implements _TrashOfDay {
  const _$_TrashOfDay({required this.targetDay, required this.trashType});

  factory _$_TrashOfDay.fromJson(Map<String, dynamic> json) =>
      _$$_TrashOfDayFromJson(json);

  @override
  final TargetDay targetDay;
  @override
  final String trashType;

  @override
  String toString() {
    return 'TrashOfDay(targetDay: $targetDay, trashType: $trashType)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TrashOfDay &&
            (identical(other.targetDay, targetDay) ||
                other.targetDay == targetDay) &&
            (identical(other.trashType, trashType) ||
                other.trashType == trashType));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, targetDay, trashType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TrashOfDayCopyWith<_$_TrashOfDay> get copyWith =>
      __$$_TrashOfDayCopyWithImpl<_$_TrashOfDay>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_TrashOfDayToJson(
      this,
    );
  }
}

abstract class _TrashOfDay implements TrashOfDay {
  const factory _TrashOfDay(
      {required final TargetDay targetDay,
      required final String trashType}) = _$_TrashOfDay;

  factory _TrashOfDay.fromJson(Map<String, dynamic> json) =
      _$_TrashOfDay.fromJson;

  @override
  TargetDay get targetDay;
  @override
  String get trashType;
  @override
  @JsonKey(ignore: true)
  _$$_TrashOfDayCopyWith<_$_TrashOfDay> get copyWith =>
      throw _privateConstructorUsedError;
}
