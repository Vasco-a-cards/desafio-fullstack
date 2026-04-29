import 'package:flutter/material.dart';

/// Opens a bottom-sheet with three scroll wheels (day | month | year).
/// Returns the selected [DateTime] or null if dismissed.
Future<DateTime?> showDateScrollPicker(
  BuildContext context, {
  DateTime? initialDate,
  DateTime? minDate,
  DateTime? maxDate,
}) {
  final now = DateTime.now();
  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _DateScrollPicker(
      initialDate: initialDate ?? DateTime(now.year - 25, now.month, now.day),
      minDate: minDate ?? DateTime(1900),
      maxDate: maxDate ?? now,
    ),
  );
}

// ---------------------------------------------------------------------------

class _DateScrollPicker extends StatefulWidget {
  const _DateScrollPicker({
    required this.initialDate,
    required this.minDate,
    required this.maxDate,
  });

  final DateTime initialDate;
  final DateTime minDate;
  final DateTime maxDate;

  @override
  State<_DateScrollPicker> createState() => _DateScrollPickerState();
}

class _DateScrollPickerState extends State<_DateScrollPicker> {
  static const _months = [
    'Janeiro', 'Fevereiro', 'Março', 'Abril',
    'Maio', 'Junho', 'Julho', 'Agosto',
    'Setembro', 'Outubro', 'Novembro', 'Dezembro',
  ];

  late int _day, _month, _year;
  late FixedExtentScrollController _dayCtrl;
  late FixedExtentScrollController _monthCtrl;
  late FixedExtentScrollController _yearCtrl;

  @override
  void initState() {
    super.initState();
    _day   = widget.initialDate.day;
    _month = widget.initialDate.month;
    _year  = widget.initialDate.year;

    _dayCtrl   = FixedExtentScrollController(initialItem: _day - 1);
    _monthCtrl = FixedExtentScrollController(initialItem: _month - 1);
    _yearCtrl  = FixedExtentScrollController(
      initialItem: _year - widget.minDate.year,
    );
  }

  @override
  void dispose() {
    _dayCtrl.dispose();
    _monthCtrl.dispose();
    _yearCtrl.dispose();
    super.dispose();
  }

  int _daysInMonth(int month, int year) => DateTime(year, month + 1, 0).day;

  void _clampDay() {
    final max = _daysInMonth(_month, _year);
    if (_day > max) {
      _day = max;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _dayCtrl.hasClients) {
          _dayCtrl.animateToItem(
            _day - 1,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void _onDayChanged(int i)   => setState(() => _day   = i + 1);
  void _onMonthChanged(int i) => setState(() { _month = i + 1; _clampDay(); });
  void _onYearChanged(int i)  => setState(() { _year  = widget.minDate.year + i; _clampDay(); });

  DateTime get _selected => DateTime(_year, _month, _day);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final yearCount = widget.maxDate.year - widget.minDate.year + 1;
    final dayCount  = _daysInMonth(_month, _year);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── handle ──────────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 2),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // ── header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: cs.onSurfaceVariant),
                  ),
                ),
                Text('Data de nascimento', style: tt.titleSmall),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      color: cs.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, color: cs.outlineVariant),
          const SizedBox(height: 4),

          // ── wheels ──────────────────────────────────────────────────────
          SizedBox(
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Selection band
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withValues(alpha: 0.45),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                // The three wheels
                Row(
                  children: [
                    // Day
                    Expanded(
                      flex: 2,
                      child: _Wheel(
                        controller: _dayCtrl,
                        itemCount: dayCount,
                        onChanged: _onDayChanged,
                        fadeColor: cs.surface,
                        builder: (i) => Text(
                          '${i + 1}'.padLeft(2, '0'),
                          style: tt.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Month
                    Expanded(
                      flex: 5,
                      child: _Wheel(
                        controller: _monthCtrl,
                        itemCount: 12,
                        onChanged: _onMonthChanged,
                        fadeColor: cs.surface,
                        builder: (i) => Text(
                          _months[i],
                          style: tt.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),

                    // Year
                    Expanded(
                      flex: 3,
                      child: _Wheel(
                        controller: _yearCtrl,
                        itemCount: yearCount,
                        onChanged: _onYearChanged,
                        fadeColor: cs.surface,
                        builder: (i) => Text(
                          '${widget.minDate.year + i}',
                          style: tt.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------

class _Wheel extends StatelessWidget {
  const _Wheel({
    required this.controller,
    required this.itemCount,
    required this.onChanged,
    required this.builder,
    required this.fadeColor,
  });

  final FixedExtentScrollController controller;
  final int itemCount;
  final ValueChanged<int> onChanged;
  final Widget Function(int) builder;
  final Color fadeColor;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          fadeColor,
          fadeColor.withValues(alpha: 0),
          fadeColor.withValues(alpha: 0),
          fadeColor,
        ],
        stops: const [0.0, 0.22, 0.78, 1.0],
      ).createShader(bounds),
      blendMode: BlendMode.srcOver,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 44,
        perspective: 0.003,
        diameterRatio: 2.2,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: itemCount,
          builder: (_, i) => Center(child: builder(i)),
        ),
      ),
    );
  }
}
