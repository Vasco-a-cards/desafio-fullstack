import 'package:dio/dio.dart';
import 'dev_model.dart';

class DevRepository {
  const DevRepository(this._dio);

  final Dio _dio;

  /// Returns the paginated dev list plus the total count from X-Total-Count.
  Future<({List<Dev> devs, int total})> list({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      '/devs',
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final total = int.tryParse(
          response.headers.value('X-Total-Count') ?? '',
        ) ??
        0;

    final devs = (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Dev.fromJson)
        .toList();

    return (devs: devs, total: total);
  }

  /// Full-text / trigram search via ?terms=.
  Future<List<Dev>> search(String terms) async {
    final response = await _dio.get<List<dynamic>>(
      '/devs',
      queryParameters: {'terms': terms},
    );

    return (response.data ?? [])
        .cast<Map<String, dynamic>>()
        .map(Dev.fromJson)
        .toList();
  }

  Future<Dev> getById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>('/devs/$id');
    return Dev.fromJson(response.data!);
  }

  Future<Dev> create(Map<String, dynamic> data) async {
    final response =
        await _dio.post<Map<String, dynamic>>('/devs', data: data);
    return Dev.fromJson(response.data!);
  }
}
