import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/devs_providers.dart';
import '../widgets/dev_card.dart';
import '../../data/dev_model.dart';

class DevsListPage extends ConsumerStatefulWidget {
  const DevsListPage({super.key});

  @override
  ConsumerState<DevsListPage> createState() => _DevsListPageState();
}

class _DevsListPageState extends ConsumerState<DevsListPage> {
  final _searchCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _searching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 380), () {
      ref.read(searchTermsProvider.notifier).state = value.trim();
    });
  }

  void _clearSearch() {
    _debounce?.cancel();
    _searchCtrl.clear();
    ref.read(searchTermsProvider.notifier).state = '';
    setState(() => _searching = false);
  }

  AsyncValue<List<Dev>> get _devsValue {
    if (_searching) {
      return ref.watch(devSearchProvider);
    }
    return ref.watch(devListProvider).whenData((r) => r.devs);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final listAsync = ref.watch(devListProvider);

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchCtrl,
                focusNode: _focusNode,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Pesquisar devs…',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  isDense: true,
                ),
                onChanged: _onSearchChanged,
              )
            : const Text('Dynamik Devs'),
        actions: [
          if (_searching)
            IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Cancelar pesquisa',
              onPressed: _clearSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search_rounded),
              tooltip: 'Pesquisar',
              onPressed: () {
                setState(() => _searching = true);
                Future.microtask(() => _focusNode.requestFocus());
              },
            ),
        ],
      ),
      floatingActionButton: _searching
          ? null
          : FloatingActionButton.extended(
              heroTag: 'fab-create-dev',
              onPressed: () => context.push('/devs/new'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Novo dev'),
            ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total count chip — only shown in list mode
          if (!_searching)
            listAsync.maybeWhen(
              data: (r) => Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Text(
                  '${r.total} desenvolvedor${r.total == 1 ? '' : 'es'}',
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),

          Expanded(
            child: _devsValue.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => _ErrorState(
                onRetry: () => ref.invalidate(
                  _searching ? devSearchProvider : devListProvider,
                ),
              ),
              data: (devs) {
                if (devs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.manage_search_rounded,
                          size: 56,
                          color: cs.onSurfaceVariant.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _searching
                              ? 'Sem resultados para "${_searchCtrl.text}"'
                              : 'Nenhum dev encontrado',
                          style: tt.bodyLarge
                              ?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(devListProvider);
                    await ref.read(devListProvider.future);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: devs.length,
                    itemBuilder: (_, i) => DevCard(dev: devs[i]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.wifi_off_rounded, size: 56, color: cs.error),
          const SizedBox(height: 16),
          Text('Não foi possível carregar', style: tt.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Verifica a ligação e tenta novamente.',
            style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
          ),
          const SizedBox(height: 20),
          FilledButton.tonal(
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
