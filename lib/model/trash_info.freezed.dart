// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'trash_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$TrashInfo {
  String get trashType => throw _privateConstructorUsedError;
  Map<int, bool> get daysOfWeek => throw _privateConstructorUsedError;
  Map<int, bool> get weeksOfMonth => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TrashInfoCopyWith<TrashInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrashInfoCopyWith<$Res> {
  factory $TrashInfoCopyWith(TrashInfo value, $Res Function(TrashInfo) then) =
      _$TrashInfoCopyWithImpl<$Res, TrashInfo>;
  @useResult
  $Res call(
      {String trashType,
      Map<int, bool> daysOfWeek,
      Map<int, bool> weeksOfMonth});
}

/// @nodoc
class _$TrashInfoCopyWithImpl<$Res, $Val extends TrashInfo>
    implements $TrashInfoCopyWith<$Res> {
  _$TrashInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trashType = null,
    Object? daysOfWeek = null,
    Object? weeksOfMonth = null,
  }) {
    return _then(_value.copyWith(
      trashType: null == trashType
          ? _value.trashType
          : trashType // ignore: cast_nullable_to_non_nullable
              as String,
      daysOfWeek: null == daysOfWeek
          ? _value.daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      weeksOfMonth: null == weeksOfMonth
          ? _value.weeksOfMonth
          : weeksOfMonth // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_TrashInfoCopyWith<$Res> implements $TrashInfoCopyWith<$Res> {
  factory _$$_TrashInfoCopyWith(
          _$_TrashInfo value, $Res Function(_$_TrashInfo) then) =
      __$$_TrashInfoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String trashType,
      Map<int, bool> daysOfWeek,
      Map<int, bool> weeksOfMonth});
}

/// @nodoc
class __$$_TrashInfoCopyWithImpl<$Res>
    extends _$TrashInfoCopyWithImpl<$Res, _$_TrashInfo>
    implements _$$_TrashInfoCopyWith<$Res> {
  __$$_TrashInfoCopyWithImpl(
      _$_TrashInfo _value, $Res Function(_$_TrashInfo) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trashType = null,
    Object? daysOfWeek = null,
    Object? weeksOfMonth = null,
  }) {
    return _then(_$_TrashInfo(
      trashType: null == trashType
          ? _value.trashType
          : trashType // ignore: cast_nullable_to_non_nullable
              as String,
      daysOfWeek: null == daysOfWeek
          ? _value._daysOfWeek
          : daysOfWeek // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
      weeksOfMonth: null == weeksOfMonth
          ? _value._weeksOfMonth
          : weeksOfMonth // ignore: cast_nullable_to_non_nullable
              as Map<int, bool>,
    ));
  }
}

/// @nodoc

class _$_TrashInfo implements _TrashInfo {
  const _$_TrashInfo(
      {this.trashType = '',
      final Map<int, bool> daysOfWeek = const {
        1: false,
        2: false,
        3: false,
        4: false,
        5: false,
        6: false,
        7: false
      },
      final Map<int, bool> weeksOfMonth = const {
        1: true,
        2: true,
        3: true,
        4: true,
        5: true
      }})
      : _daysOfWeek = daysOfWeek,
        _weeksOfMonth = weeksOfMonth;

  @override
  @JsonKey()
  final String trashType;
  final Map<int, bool> _daysOfWeek;
  @override
  @JsonKey()
  Map<int, bool> get daysOfWeek {
    if (_daysOfWeek is EqualUnmodifiableMapView) return _daysOfWeek;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_daysOfWeek);
  }

  final Map<int, bool> _weeksOfMonth;
  @override
  @JsonKey()
  Map<int, bool> get weeksOfMonth {
    if (_weeksOfMonth is EqualUnmodifiableMapView) return _weeksOfMonth;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_weeksOfMonth);
  }

  @override
  String toString() {
    return 'TrashInfo(trashType: $trashType, daysOfWeek: $daysOfWeek, weeksOfMonth: $weeksOfMonth)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_TrashInfo &&
            (identical(other.trashType, trashType) ||
                other.trashType == trashType) &&
            const DeepCollectionEquality()
                .equals(other._daysOfWeek, _daysOfWeek) &&
            const DeepCollectionEquality()
                .equals(other._weeksOfMonth, _weeksOfMonth));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      trashType,
      const DeepCollectionEquality().hash(_daysOfWeek),
      const DeepCollectionEquality().hash(_weeksOfMonth));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_TrashInfoCopyWith<_$_TrashInfo> get copyWith =>
      __$$_TrashInfoCopyWithImpl<_$_TrashInfo>(this, _$identity);
}

abstract class _TrashInfo implements TrashInfo {
  const factory _TrashInfo(
      {final String trashType,
      final Map<int, bool> daysOfWeek,
      final Map<int, bool> weeksOfMonth}) = _$_TrashInfo;

  @override
  String get trashType;
  @override
  Map<int, bool> get daysOfWeek;
  @override
  Map<int, bool> get weeksOfMonth;
  @override
  @JsonKey(ignore: true)
  _$$_TrashInfoCopyWith<_$_TrashInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
