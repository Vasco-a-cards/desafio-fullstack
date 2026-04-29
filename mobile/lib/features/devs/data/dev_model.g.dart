// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dev_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Dev _$DevFromJson(Map<String, dynamic> json) => _Dev(
  id: json['id'] as String,
  nickname: json['nickname'] as String,
  name: json['name'] as String,
  birthDate: json['birth_date'] as String,
  stack: (json['stack'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$DevToJson(_Dev instance) => <String, dynamic>{
  'id': instance.id,
  'nickname': instance.nickname,
  'name': instance.name,
  'birth_date': instance.birthDate,
  'stack': instance.stack,
};
