// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dev_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Dev {

 String get id; String get nickname; String get name;@JsonKey(name: 'birth_date') String get birthDate; List<String>? get stack;
/// Create a copy of Dev
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DevCopyWith<Dev> get copyWith => _$DevCopyWithImpl<Dev>(this as Dev, _$identity);

  /// Serializes this Dev to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Dev&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other.stack, stack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,name,birthDate,const DeepCollectionEquality().hash(stack));

@override
String toString() {
  return 'Dev(id: $id, nickname: $nickname, name: $name, birthDate: $birthDate, stack: $stack)';
}


}

/// @nodoc
abstract mixin class $DevCopyWith<$Res>  {
  factory $DevCopyWith(Dev value, $Res Function(Dev) _then) = _$DevCopyWithImpl;
@useResult
$Res call({
 String id, String nickname, String name,@JsonKey(name: 'birth_date') String birthDate, List<String>? stack
});




}
/// @nodoc
class _$DevCopyWithImpl<$Res>
    implements $DevCopyWith<$Res> {
  _$DevCopyWithImpl(this._self, this._then);

  final Dev _self;
  final $Res Function(Dev) _then;

/// Create a copy of Dev
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? nickname = null,Object? name = null,Object? birthDate = null,Object? stack = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,stack: freezed == stack ? _self.stack : stack // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Dev].
extension DevPatterns on Dev {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Dev value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Dev() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Dev value)  $default,){
final _that = this;
switch (_that) {
case _Dev():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Dev value)?  $default,){
final _that = this;
switch (_that) {
case _Dev() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String nickname,  String name, @JsonKey(name: 'birth_date')  String birthDate,  List<String>? stack)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Dev() when $default != null:
return $default(_that.id,_that.nickname,_that.name,_that.birthDate,_that.stack);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String nickname,  String name, @JsonKey(name: 'birth_date')  String birthDate,  List<String>? stack)  $default,) {final _that = this;
switch (_that) {
case _Dev():
return $default(_that.id,_that.nickname,_that.name,_that.birthDate,_that.stack);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String nickname,  String name, @JsonKey(name: 'birth_date')  String birthDate,  List<String>? stack)?  $default,) {final _that = this;
switch (_that) {
case _Dev() when $default != null:
return $default(_that.id,_that.nickname,_that.name,_that.birthDate,_that.stack);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Dev implements Dev {
  const _Dev({required this.id, required this.nickname, required this.name, @JsonKey(name: 'birth_date') required this.birthDate, final  List<String>? stack}): _stack = stack;
  factory _Dev.fromJson(Map<String, dynamic> json) => _$DevFromJson(json);

@override final  String id;
@override final  String nickname;
@override final  String name;
@override@JsonKey(name: 'birth_date') final  String birthDate;
 final  List<String>? _stack;
@override List<String>? get stack {
  final value = _stack;
  if (value == null) return null;
  if (_stack is EqualUnmodifiableListView) return _stack;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Dev
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DevCopyWith<_Dev> get copyWith => __$DevCopyWithImpl<_Dev>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DevToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Dev&&(identical(other.id, id) || other.id == id)&&(identical(other.nickname, nickname) || other.nickname == nickname)&&(identical(other.name, name) || other.name == name)&&(identical(other.birthDate, birthDate) || other.birthDate == birthDate)&&const DeepCollectionEquality().equals(other._stack, _stack));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,nickname,name,birthDate,const DeepCollectionEquality().hash(_stack));

@override
String toString() {
  return 'Dev(id: $id, nickname: $nickname, name: $name, birthDate: $birthDate, stack: $stack)';
}


}

/// @nodoc
abstract mixin class _$DevCopyWith<$Res> implements $DevCopyWith<$Res> {
  factory _$DevCopyWith(_Dev value, $Res Function(_Dev) _then) = __$DevCopyWithImpl;
@override @useResult
$Res call({
 String id, String nickname, String name,@JsonKey(name: 'birth_date') String birthDate, List<String>? stack
});




}
/// @nodoc
class __$DevCopyWithImpl<$Res>
    implements _$DevCopyWith<$Res> {
  __$DevCopyWithImpl(this._self, this._then);

  final _Dev _self;
  final $Res Function(_Dev) _then;

/// Create a copy of Dev
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? nickname = null,Object? name = null,Object? birthDate = null,Object? stack = freezed,}) {
  return _then(_Dev(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,nickname: null == nickname ? _self.nickname : nickname // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,birthDate: null == birthDate ? _self.birthDate : birthDate // ignore: cast_nullable_to_non_nullable
as String,stack: freezed == stack ? _self._stack : stack // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}

// dart format on
