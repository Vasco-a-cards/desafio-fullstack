import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/errors/api_exception.dart';
import '../providers/devs_providers.dart';

class DevCreatePage extends ConsumerStatefulWidget {
  const DevCreatePage({super.key});

  @override
  ConsumerState<DevCreatePage> createState() => _DevCreatePageState();
}

class _DevCreatePageState extends ConsumerState<DevCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nicknameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _stackInputCtrl = TextEditingController();
  final _stackFocus = FocusNode();

  DateTime? _birthDate;
  List<String> _stack = [];
  bool _loading = false;
  bool _submitted = false;
  Map<String, String> _apiErrors = {};

  static final _birthFmt = DateFormat('dd/MM/yyyy');
  static final _apiFmt = DateFormat('yyyy-MM-dd');

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    _nameCtrl.dispose();
    _birthDateCtrl.dispose();
    _stackInputCtrl.dispose();
    _stackFocus.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  void _clearApiError(String field) {
    if (_apiErrors.containsKey(field)) {
      setState(() => _apiErrors = {..._apiErrors}..remove(field));
    }
  }

  void _showSnackbar(String msg) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          behavior: SnackBarBehavior.floating,
          width: 340,
        ),
      );
  }

  // ── Date picker ───────────────────────────────────────────────────────────

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initial = _birthDate ?? DateTime(now.year - 25, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: 'Data de nascimento',
    );
    if (picked == null || !mounted) return;
    setState(() {
      _birthDate = picked;
      _birthDateCtrl.text = _birthFmt.format(picked);
    });
    _clearApiError('birth_date');
    if (_submitted) _formKey.currentState?.validate();
  }

  // ── Stack ─────────────────────────────────────────────────────────────────

  void _addStack() {
    final value = _stackInputCtrl.text.trim().toUpperCase();
    if (value.isEmpty) return;
    if (_stack.contains(value)) {
      _stackInputCtrl.clear();
      return;
    }
    setState(() {
      _stack = [..._stack, value];
      _stackInputCtrl.clear();
    });
    _stackFocus.requestFocus();
  }

  void _removeStack(String item) {
    setState(() => _stack = _stack.where((s) => s != item).toList());
  }

  // ── Validators ────────────────────────────────────────────────────────────

  String? _validateNickname(String? v) {
    if (_apiErrors.containsKey('nickname')) return _apiErrors['nickname'];
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    if (v.trim().length > 32) return 'Máximo 32 caracteres';
    return null;
  }

  String? _validateName(String? v) {
    if (_apiErrors.containsKey('name')) return _apiErrors['name'];
    if (v == null || v.trim().isEmpty) return 'Campo obrigatório';
    if (v.trim().length > 100) return 'Máximo 100 caracteres';
    return null;
  }

  String? _validateBirthDate(String? _) {
    if (_apiErrors.containsKey('birth_date')) return _apiErrors['birth_date'];
    if (_birthDate == null) return 'Seleciona uma data de nascimento';
    final age = _calcAge(_birthDate!);
    if (age < 0) return 'Data inválida';
    return null;
  }

  static int _calcAge(DateTime birth) {
    final now = DateTime.now();
    int age = now.year - birth.year;
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    setState(() {
      _submitted = true;
      _apiErrors = {};
    });
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final data = <String, dynamic>{
        'nickname': _nicknameCtrl.text.trim(),
        'name': _nameCtrl.text.trim(),
        'birth_date': _apiFmt.format(_birthDate!),
        if (_stack.isNotEmpty) 'stack': _stack,
      };

      final dev = await ref.read(devRepositoryProvider).create(data);
      if (!mounted) return;

      ref.invalidate(devListProvider);
      context.replace('/devs/${dev.id}');
    } on DioException catch (e) {
      if (!mounted) return;
      final err = e.error;

      if (err is ValidationException) {
        final mapped = Map<String, String>.fromEntries(
          err.errors.entries.map((e) {
            final msg = e.key == 'nickname'
                ? 'Este nickname já existe'
                : e.value.first;
            return MapEntry(e.key, msg);
          }),
        );
        setState(() => _apiErrors = mapped);
        // Trigger form to display the API errors
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _formKey.currentState?.validate();
        });
      } else if (err is BadRequestException) {
        _showSnackbar('Verifica os dados enviados');
      } else {
        // null error = network / timeout (interceptor passes through)
        _showSnackbar('Sem ligação ao servidor');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Criar Dev')),
      body: Form(
        key: _formKey,
        autovalidateMode: _submitted
            ? AutovalidateMode.onUserInteraction
            : AutovalidateMode.disabled,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Informações básicas ──────────────────────────────────
              _SectionLabel('Informações básicas'),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nicknameCtrl,
                textInputAction: TextInputAction.next,
                maxLength: 32,
                decoration: const InputDecoration(
                  labelText: 'Nickname *',
                  hintText: 'ex: johndoe',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
                validator: _validateNickname,
                onChanged: (_) => _clearApiError('nickname'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameCtrl,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome completo *',
                  hintText: 'ex: João Domingues',
                  prefixIcon: Icon(Icons.badge_rounded),
                ),
                validator: _validateName,
                onChanged: (_) => _clearApiError('name'),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _birthDateCtrl,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Data de nascimento *',
                  hintText: 'Seleciona uma data',
                  prefixIcon: Icon(Icons.cake_rounded),
                  suffixIcon: Icon(Icons.calendar_month_rounded),
                ),
                validator: _validateBirthDate,
              ),

              // ── Stack ────────────────────────────────────────────────
              const SizedBox(height: 36),
              _SectionLabel('Stack tecnológica'),
              const SizedBox(height: 6),
              Text(
                'Opcional — adiciona as tecnologias que dominas.',
                style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 14),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _stackInputCtrl,
                      focusNode: _stackFocus,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.characters,
                      decoration: const InputDecoration(
                        labelText: 'Tecnologia',
                        hintText: 'ex: FLUTTER',
                      ),
                      onSubmitted: (_) => _addStack(),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: FilledButton.tonal(
                      onPressed: _addStack,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(0, 56),
                      ),
                      child: const Text('Adicionar'),
                    ),
                  ),
                ],
              ),

              if (_stack.isNotEmpty) ...[
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: _stack
                      .map(
                        (s) => Chip(
                          label: Text(s),
                          onDeleted: () => _removeStack(s),
                          deleteIcon: Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],

              // ── Botão ─────────────────────────────────────────────────
              const SizedBox(height: 44),
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: cs.onPrimary,
                          ),
                        )
                      : const Text(
                          'Criar Dev',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared section header ──────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: tt.labelSmall?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Divider(color: cs.outlineVariant, thickness: 1)),
      ],
    );
  }
}
