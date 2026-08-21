import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/main.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/dialogs.dart';
import 'package:loan_calculator/ui/widgets.dart';

/// Saved calculations. Popping with a [History] hands it back to the
/// Advanced Loan screen to reload.
class HistoryScreen extends StatefulWidget {
  static const String route = '/history';
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final Box _box = Hive.box(historyBox);

  /// Box keys in the same (newest-first) order as the visible list, so that
  /// deleting row N removes the record the user actually tapped.
  List<dynamic> get _keys => _box.keys.toList().reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved calculations'),
        actions: [
          ValueListenableBuilder(
            valueListenable: _box.listenable(),
            builder: (context, box, _) => box.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    tooltip: 'Clear all',
                    icon: const Icon(Icons.delete_sweep_outlined),
                    onPressed: _clearAll,
                  ),
          ),
          const SizedBox(width: AppSpace.xs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ValueListenableBuilder(
          valueListenable: _box.listenable(),
          builder: (context, Box box, _) {
            final keys = _keys;
            if (keys.isEmpty) {
              return const EmptyState(
                icon: Icons.history_rounded,
                title: 'No saved calculations',
                message:
                    'Tap Save on the Advanced Loan screen to keep a result here.',
              );
            }
            return ListView.separated(
              padding: const EdgeInsets.all(AppSpace.lg),
              itemCount: keys.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSpace.md),
              itemBuilder: (context, i) {
                final entry = box.get(keys[i]);
                if (entry is! History) return const SizedBox.shrink();
                return _HistoryCard(
                  entry: entry,
                  onOpen: () => Navigator.pop(context, entry),
                  onDelete: () => _delete(keys[i], entry),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _delete(dynamic key, History entry) async {
    final ok = await confirm(
      context,
      title: 'Delete calculation?',
      message: 'This removes the entry saved on ${entry.calculationDate}.',
    );
    if (ok) await _box.delete(key);
  }

  Future<void> _clearAll() async {
    final ok = await confirm(
      context,
      title: 'Clear all history?',
      message: 'Every saved calculation will be removed. This cannot be undone.',
      confirmLabel: 'Clear all',
    );
    if (ok) await _box.clear();
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({
    required this.entry,
    required this.onOpen,
    required this.onDelete,
  });

  final History entry;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final m = entry.mortgageData;
    final r = entry.resultData;

    return Material(
      color: scheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.md),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(AppSpace.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.calculationDate ?? 'Saved calculation',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Delete',
                    icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: AppSpace.sm),
              Text(
                r?.monthlyPayment ?? '--',
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w700),
              ),
              Text(
                'per month',
                style:
                    TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: AppSpace.md),
              const Divider(),
              DetailRow(
                  label: 'Loan amount', value: money(m?.loanAmount ?? 0)),
              DetailRow(
                  label: 'Rate / term',
                  value:
                      '${m?.interest ?? 0}% · ${(m?.loanTerm ?? 0).toStringAsFixed(0)} mo'),
              DetailRow(
                  label: 'Total interest',
                  value: r?.totalInterest ?? '--',
                  emphasise: true),
            ],
          ),
        ),
      ),
    );
  }
}
