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

  // #1 — refresh ao voltar à lista
  GoRouterDelegate? _delegate;
  bool _wasAtRoot = true;

  @override
  void initState() {
    super.initState();
    // #2 — sincroniza campo de pesquisa com o provider (widget recriado ou hot-restart)
    final savedTerms = ref.read(searchTermsProvider);
    if (savedTerms.isNotEmpty) {
      _searching = true;
      _searchCtrl.text = savedTerms;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // #1 — ouve mudanças de rota através do routerDelegate
    final delegate = GoRouter.of(context).routerDelegate;
    if (delegate != _delegate) {
      _delegate?.removeListener(_onRouteChanged);
      _delegate = delegate;
      _delegate!.addListener(_onRouteChanged);
    }
  }

  void _onRouteChanged() {
    final path = _delegate?.currentConfiguration.uri.path ?? '/';
    final isAtRoot = path == '/';
    // Só invalida quando regressa à lista (não no carregamento inicial)
    if (isAtRoot && !_wasAtRoot) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ref.invalidate(devListProvider);
      });
    }
    _wasAtRoot = isAtRoot;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _delegate?.removeListener(_onRouteChanged);
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
    if (_searching) return ref.watch(devSearchProvider);
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
                decoration: const InputDecoration(
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
              // #3 — skeleton em vez de spinner
              loading: () => const _ListSkeleton(),
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

// ---------------------------------------------------------------------------
// #3 — Skeleton da lista
// ---------------------------------------------------------------------------

class _ListSkeleton extends StatefulWidget {
  const _ListSkeleton();

  @override
  State<_ListSkeleton> createState() => _ListSkeletonState();
}

class _ListSkeletonState extends State<_ListSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.onSurface;
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        final shade = base.withValues(alpha: 0.06 + _ctrl.value * 0.08);
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(top: 8),
          itemCount: 6,
          itemBuilder: (_, __) => _SkeletonCard(shade: shade),
        );
      },
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.shade});

  final Color shade;

  Widget _box({double? w, double? h, bool circle = false}) => Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          color: shade,
          shape: circle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: circle ? null : BorderRadius.circular(8),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            _box(w: 56, h: 56, circle: true),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(w: 120, h: 16),
                  const SizedBox(height: 8),
                  _box(w: 180, h: 13),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _box(w: 56, h: 24),
                      const SizedBox(width: 6),
                      _box(w: 44, h: 24),
                      const SizedBox(width: 6),
                      _box(w: 68, h: 24),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// #5 — Error state com feedback de loading no retry
// ---------------------------------------------------------------------------

class _ErrorState extends StatefulWidget {
  const _ErrorState({required this.onRetry});

  final VoidCallback onRetry;

  @override
  State<_ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<_ErrorState> {
  bool _loading = false;

  void _handleRetry() {
    setState(() => _loading = true);
    widget.onRetry();
  }

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
            onPressed: _loading ? null : _handleRetry,
            child: _loading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}
