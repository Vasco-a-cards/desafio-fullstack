import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/dio_client.dart';
import '../../data/dev_model.dart';
import '../../data/dev_repository.dart';

// ---------------------------------------------------------------------------
// Infrastructure
// ---------------------------------------------------------------------------

final dioProvider = Provider((ref) => buildDioClient());

final devRepositoryProvider = Provider(
  (ref) => DevRepository(ref.watch(dioProvider)),
);

// ---------------------------------------------------------------------------
// Dev list
// ---------------------------------------------------------------------------

typedef DevListResult = ({List<Dev> devs, int total});

final devListProvider = FutureProvider<DevListResult>((ref) async {
  return ref.watch(devRepositoryProvider).list();
});

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------

final searchTermsProvider = StateProvider<String>((ref) => '');

final devSearchProvider = FutureProvider<List<Dev>>((ref) async {
  final terms = ref.watch(searchTermsProvider);
  if (terms.trim().isEmpty) return [];
  return ref.watch(devRepositoryProvider).search(terms);
});

// ---------------------------------------------------------------------------
// Single dev by id
// ---------------------------------------------------------------------------

final devByIdProvider = FutureProvider.family<Dev, String>((ref, id) async {
  return ref.watch(devRepositoryProvider).getById(id);
});
