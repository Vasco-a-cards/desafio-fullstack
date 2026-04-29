import 'package:freezed_annotation/freezed_annotation.dart';

part 'dev_model.freezed.dart';
part 'dev_model.g.dart';

@freezed
abstract class Dev with _$Dev {
  const factory Dev({
    required String id,
    required String nickname,
    required String name,
    @JsonKey(name: 'birth_date') required String birthDate,
    List<String>? stack,
  }) = _Dev;

  factory Dev.fromJson(Map<String, dynamic> json) => _$DevFromJson(json);
}
