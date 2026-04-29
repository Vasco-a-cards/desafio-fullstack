import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/errors/api_exception.dart';
import '../../data/dev_model.dart';
import '../providers/devs_providers.dart';
import '../widgets/dev_card.dart';

class DevDetailPage extends ConsumerStatefulWidget {
  const DevDetailPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<DevDetailPage> createState() => _DevDetailPageState();
}

class _DevDetailPageState extends ConsumerState<DevDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enterCtrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _enterCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _opacity =
        CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _enterCtrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _enterCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(devByIdProvider(widget.id), (_, next) {
      if (next.hasValue && !_enterCtrl.isCompleted) _enterCtrl.forward();
    });

    final devAsync = ref.watch(devByIdProvider(widget.id));

    return Scaffold(
      appBar: AppBar(
        title: devAsync.maybeWhen(
          data: (dev) => Text('@${dev.nickname}'),
          orElse: () => const Text('Perfil'),
        ),
      ),
      body: devAsync.when(
        loading: () => const _DetailSkeleton(),
        error: _buildError,
        data: (dev) => FadeTransition(
          opacity: _opacity,
          child: SlideTransition(
            position: _slide,
            child: _DevContent(dev: dev, heroTag: 'dev-avatar-${widget.id}'),
          ),
        ),
      ),
    );
  }

  Widget _buildError(Object err, StackTrace? _) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final isNotFound = err is DioException && err.error is NotFoundException;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isNotFound
                  ? Icons.person_off_outlined
                  : Icons.wifi_off_rounded,
              size: 72,
              color: cs.onSurfaceVariant.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 20),
            Text(
              isNotFound ? 'Dev não encontrado' : 'Erro ao carregar',
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isNotFound
                  ? 'O dev que procuras não existe ou foi removido.'
                  : 'Verifica a ligação e tenta novamente.',
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            if (!isNotFound) ...[
              const SizedBox(height: 24),
              FilledButton.tonal(
                onPressed: () =>
                    ref.invalidate(devByIdProvider(widget.id)),
                child: const Text('Tentar novamente'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Content
// ---------------------------------------------------------------------------

class _DevContent extends StatelessWidget {
  const _DevContent({required this.dev, required this.heroTag});

  final Dev dev;
  final String heroTag;

  static int _calcAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final birth = DateTime.tryParse(dev.birthDate);
    final age = birth != null ? _calcAge(birth) : null;
    final formattedDate = birth != null
        ? DateFormat('dd/MM/yyyy').format(birth)
        : dev.birthDate;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  cs.primaryContainer.withValues(alpha: 0.45),
                  cs.surface,
                ],
              ),
            ),
            padding:
                const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            child: Column(
              children: [
                Hero(
                  tag: heroTag,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: cs.primaryContainer,
                    child: Text(
                      DevAvatar.initials(dev.name),
                      style: TextStyle(
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w800,
                        fontSize: 34,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '@${dev.nickname}',
                  style: tt.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dev.name,
                  style:
                      tt.titleSmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cs.outlineVariant),

          // ── Info ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(
                  icon: Icons.cake_rounded,
                  label: 'Data de nascimento',
                  value: formattedDate,
                ),
                if (age != null) ...[
                  const SizedBox(height: 20),
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Idade',
                    value: '$age anos',
                  ),
                ],
                if (dev.stack != null && dev.stack!.isNotEmpty) ...[
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Icon(
                        Icons.code_rounded,
                        size: 18,
                        color: cs.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Stack',
                        style: tt.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: dev.stack!
                        .map(
                          (s) => Chip(
                            label: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: cs.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: cs.primary),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: tt.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Skeleton
// ---------------------------------------------------------------------------

class _DetailSkeleton extends StatefulWidget {
  const _DetailSkeleton();

  @override
  State<_DetailSkeleton> createState() => _DetailSkeletonState();
}

class _DetailSkeletonState extends State<_DetailSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
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
        final shade = base.withValues(alpha: 0.06 + _ctrl.value * 0.1);
        return _SkeletonLayout(shade: shade);
      },
    );
  }
}

class _SkeletonLayout extends StatelessWidget {
  const _SkeletonLayout({required this.shade});

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
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
            child: Column(
              children: [
                _box(w: 104, h: 104, circle: true),
                const SizedBox(height: 20),
                _box(w: 160, h: 26),
                const SizedBox(height: 8),
                _box(w: 120, h: 16),
              ],
            ),
          ),
          const Divider(height: 1),
          // Info rows
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < 2; i++) ...[
                  Row(
                    children: [
                      _box(w: 40, h: 40),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _box(w: 110, h: 12),
                          const SizedBox(height: 6),
                          _box(w: 160, h: 18),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
                // Stack section
                _box(w: 60, h: 18),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final w in [80.0, 56.0, 96.0, 64.0, 72.0])
                      _box(w: w, h: 32),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
