// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'winrate_records.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WinRateRecords {

 int? get id; int get timeAdded; int? get lastUpdated; String? get backgroundImage; double get desiredWinRate; String? get name; int get currentNumberOfBattles; double get currentWinRate; int? get progressiveWinRate;
/// Create a copy of WinRateRecords
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WinRateRecordsCopyWith<WinRateRecords> get copyWith => _$WinRateRecordsCopyWithImpl<WinRateRecords>(this as WinRateRecords, _$identity);

  /// Serializes this WinRateRecords to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WinRateRecords&&(identical(other.id, id) || other.id == id)&&(identical(other.timeAdded, timeAdded) || other.timeAdded == timeAdded)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.backgroundImage, backgroundImage) || other.backgroundImage == backgroundImage)&&(identical(other.desiredWinRate, desiredWinRate) || other.desiredWinRate == desiredWinRate)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentNumberOfBattles, currentNumberOfBattles) || other.currentNumberOfBattles == currentNumberOfBattles)&&(identical(other.currentWinRate, currentWinRate) || other.currentWinRate == currentWinRate)&&(identical(other.progressiveWinRate, progressiveWinRate) || other.progressiveWinRate == progressiveWinRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeAdded,lastUpdated,backgroundImage,desiredWinRate,name,currentNumberOfBattles,currentWinRate,progressiveWinRate);

@override
String toString() {
  return 'WinRateRecords(id: $id, timeAdded: $timeAdded, lastUpdated: $lastUpdated, backgroundImage: $backgroundImage, desiredWinRate: $desiredWinRate, name: $name, currentNumberOfBattles: $currentNumberOfBattles, currentWinRate: $currentWinRate, progressiveWinRate: $progressiveWinRate)';
}


}

/// @nodoc
abstract mixin class $WinRateRecordsCopyWith<$Res>  {
  factory $WinRateRecordsCopyWith(WinRateRecords value, $Res Function(WinRateRecords) _then) = _$WinRateRecordsCopyWithImpl;
@useResult
$Res call({
 int? id, int timeAdded, int? lastUpdated, String? backgroundImage, double desiredWinRate, String? name, int currentNumberOfBattles, double currentWinRate, int? progressiveWinRate
});




}
/// @nodoc
class _$WinRateRecordsCopyWithImpl<$Res>
    implements $WinRateRecordsCopyWith<$Res> {
  _$WinRateRecordsCopyWithImpl(this._self, this._then);

  final WinRateRecords _self;
  final $Res Function(WinRateRecords) _then;

/// Create a copy of WinRateRecords
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? timeAdded = null,Object? lastUpdated = freezed,Object? backgroundImage = freezed,Object? desiredWinRate = null,Object? name = freezed,Object? currentNumberOfBattles = null,Object? currentWinRate = null,Object? progressiveWinRate = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,timeAdded: null == timeAdded ? _self.timeAdded : timeAdded // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as int?,backgroundImage: freezed == backgroundImage ? _self.backgroundImage : backgroundImage // ignore: cast_nullable_to_non_nullable
as String?,desiredWinRate: null == desiredWinRate ? _self.desiredWinRate : desiredWinRate // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,currentNumberOfBattles: null == currentNumberOfBattles ? _self.currentNumberOfBattles : currentNumberOfBattles // ignore: cast_nullable_to_non_nullable
as int,currentWinRate: null == currentWinRate ? _self.currentWinRate : currentWinRate // ignore: cast_nullable_to_non_nullable
as double,progressiveWinRate: freezed == progressiveWinRate ? _self.progressiveWinRate : progressiveWinRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WinRateRecords].
extension WinRateRecordsPatterns on WinRateRecords {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WinRateRecords value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WinRateRecords() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WinRateRecords value)  $default,){
final _that = this;
switch (_that) {
case _WinRateRecords():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WinRateRecords value)?  $default,){
final _that = this;
switch (_that) {
case _WinRateRecords() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  int timeAdded,  int? lastUpdated,  String? backgroundImage,  double desiredWinRate,  String? name,  int currentNumberOfBattles,  double currentWinRate,  int? progressiveWinRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WinRateRecords() when $default != null:
return $default(_that.id,_that.timeAdded,_that.lastUpdated,_that.backgroundImage,_that.desiredWinRate,_that.name,_that.currentNumberOfBattles,_that.currentWinRate,_that.progressiveWinRate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  int timeAdded,  int? lastUpdated,  String? backgroundImage,  double desiredWinRate,  String? name,  int currentNumberOfBattles,  double currentWinRate,  int? progressiveWinRate)  $default,) {final _that = this;
switch (_that) {
case _WinRateRecords():
return $default(_that.id,_that.timeAdded,_that.lastUpdated,_that.backgroundImage,_that.desiredWinRate,_that.name,_that.currentNumberOfBattles,_that.currentWinRate,_that.progressiveWinRate);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  int timeAdded,  int? lastUpdated,  String? backgroundImage,  double desiredWinRate,  String? name,  int currentNumberOfBattles,  double currentWinRate,  int? progressiveWinRate)?  $default,) {final _that = this;
switch (_that) {
case _WinRateRecords() when $default != null:
return $default(_that.id,_that.timeAdded,_that.lastUpdated,_that.backgroundImage,_that.desiredWinRate,_that.name,_that.currentNumberOfBattles,_that.currentWinRate,_that.progressiveWinRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WinRateRecords extends WinRateRecords {
  const _WinRateRecords({this.id, required this.timeAdded, this.lastUpdated, this.backgroundImage, required this.desiredWinRate, this.name, required this.currentNumberOfBattles, required this.currentWinRate, this.progressiveWinRate}): super._();
  factory _WinRateRecords.fromJson(Map<String, dynamic> json) => _$WinRateRecordsFromJson(json);

@override final  int? id;
@override final  int timeAdded;
@override final  int? lastUpdated;
@override final  String? backgroundImage;
@override final  double desiredWinRate;
@override final  String? name;
@override final  int currentNumberOfBattles;
@override final  double currentWinRate;
@override final  int? progressiveWinRate;

/// Create a copy of WinRateRecords
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WinRateRecordsCopyWith<_WinRateRecords> get copyWith => __$WinRateRecordsCopyWithImpl<_WinRateRecords>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WinRateRecordsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WinRateRecords&&(identical(other.id, id) || other.id == id)&&(identical(other.timeAdded, timeAdded) || other.timeAdded == timeAdded)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.backgroundImage, backgroundImage) || other.backgroundImage == backgroundImage)&&(identical(other.desiredWinRate, desiredWinRate) || other.desiredWinRate == desiredWinRate)&&(identical(other.name, name) || other.name == name)&&(identical(other.currentNumberOfBattles, currentNumberOfBattles) || other.currentNumberOfBattles == currentNumberOfBattles)&&(identical(other.currentWinRate, currentWinRate) || other.currentWinRate == currentWinRate)&&(identical(other.progressiveWinRate, progressiveWinRate) || other.progressiveWinRate == progressiveWinRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,timeAdded,lastUpdated,backgroundImage,desiredWinRate,name,currentNumberOfBattles,currentWinRate,progressiveWinRate);

@override
String toString() {
  return 'WinRateRecords(id: $id, timeAdded: $timeAdded, lastUpdated: $lastUpdated, backgroundImage: $backgroundImage, desiredWinRate: $desiredWinRate, name: $name, currentNumberOfBattles: $currentNumberOfBattles, currentWinRate: $currentWinRate, progressiveWinRate: $progressiveWinRate)';
}


}

/// @nodoc
abstract mixin class _$WinRateRecordsCopyWith<$Res> implements $WinRateRecordsCopyWith<$Res> {
  factory _$WinRateRecordsCopyWith(_WinRateRecords value, $Res Function(_WinRateRecords) _then) = __$WinRateRecordsCopyWithImpl;
@override @useResult
$Res call({
 int? id, int timeAdded, int? lastUpdated, String? backgroundImage, double desiredWinRate, String? name, int currentNumberOfBattles, double currentWinRate, int? progressiveWinRate
});




}
/// @nodoc
class __$WinRateRecordsCopyWithImpl<$Res>
    implements _$WinRateRecordsCopyWith<$Res> {
  __$WinRateRecordsCopyWithImpl(this._self, this._then);

  final _WinRateRecords _self;
  final $Res Function(_WinRateRecords) _then;

/// Create a copy of WinRateRecords
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? timeAdded = null,Object? lastUpdated = freezed,Object? backgroundImage = freezed,Object? desiredWinRate = null,Object? name = freezed,Object? currentNumberOfBattles = null,Object? currentWinRate = null,Object? progressiveWinRate = freezed,}) {
  return _then(_WinRateRecords(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,timeAdded: null == timeAdded ? _self.timeAdded : timeAdded // ignore: cast_nullable_to_non_nullable
as int,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as int?,backgroundImage: freezed == backgroundImage ? _self.backgroundImage : backgroundImage // ignore: cast_nullable_to_non_nullable
as String?,desiredWinRate: null == desiredWinRate ? _self.desiredWinRate : desiredWinRate // ignore: cast_nullable_to_non_nullable
as double,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,currentNumberOfBattles: null == currentNumberOfBattles ? _self.currentNumberOfBattles : currentNumberOfBattles // ignore: cast_nullable_to_non_nullable
as int,currentWinRate: null == currentWinRate ? _self.currentWinRate : currentWinRate // ignore: cast_nullable_to_non_nullable
as double,progressiveWinRate: freezed == progressiveWinRate ? _self.progressiveWinRate : progressiveWinRate // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
