import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/row_data.dart';
import 'package:loan_calculator/screens/result_pdf_screen.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';

/// Full amortization schedule for one saved or live calculation.
class ResultScreen extends StatefulWidget {
  static const String route = '/result';
  const ResultScreen({super.key});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  History? _history;
  List<RowData> _schedule = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_history != null) return;
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map) {
      _history = args['history'] as History?;
      _schedule = (args['schedule'] as List<RowData>?) ?? const [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final history = _history;
    final r = history?.resultData;

    if (history == null || r == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Result')),
        body: const EmptyState(
          icon: Icons.calculate_outlined,
          title: 'Nothing to show',
          message: 'Run a calculation to see the schedule.',
        ),
      );
    }

    final hasPmi = (r.monthlyPmi ?? zeroMoney) != zeroMoney;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
        actions: [
          IconButton(
            tooltip: 'Export as PDF',
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              ResultPdfScreen.route,
              arguments: {'history': history, 'schedule': _schedule},
            ),
          ),
          const SizedBox(width: AppSpace.xs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpace.lg, AppSpace.sm, AppSpace.lg, AppSpace.lg),
              child: ResultCard(
                accent: const Color(0xFF0CA678),
                headlineLabel: 'Monthly payment (PITI)',
                headlineValue: r.monthlyPayment ?? '--',
                rows: [
                  ('Payoff date', r.lastPayment ?? '--'),
                  ('Total interest', r.totalInterest ?? '--'),
                  ('Bi-weekly payment', r.biWeeklyPayment ?? '--'),
                  ('Bi-weekly payoff', r.biWeeklyLastPayment ?? '--'),
                  ('Monthly property tax', r.monthlyTax ?? '--'),
                  ('Monthly insurance', r.monthlyIns ?? '--'),
                  if (hasPmi) ('Monthly PMI', r.monthlyPmi ?? '--'),
                  if (hasPmi) ('Total PMI', r.totalPmi ?? '--'),
                ],
                footnote: history.calculationDate,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpace.lg),
              child: Row(
                children: [
                  Text(
                    'AMORTIZATION',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_schedule.length} rows',
                    style: TextStyle(
                        fontSize: 12, color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpace.sm),
            _ScheduleHeader(),
            Expanded(
              child: _schedule.isEmpty
                  ? const EmptyState(
                      icon: Icons.table_rows_outlined,
                      title: 'No schedule',
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: AppSpace.xxl),
                      itemCount: _schedule.length,
                      itemBuilder: (context, i) =>
                          _ScheduleRow(row: _schedule[i]),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScheduleHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    const style = TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
    return Container(
      color: scheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg, vertical: AppSpace.md),
      child: const Row(
        children: [
          Expanded(flex: 4, child: Text('Period', style: style)),
          Expanded(
              flex: 3,
              child: Text('Interest',
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 3,
              child: Text('Principal',
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 3,
              child:
                  Text('Balance', textAlign: TextAlign.right, style: style)),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  const _ScheduleRow({required this.row});
  final RowData row;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Year summary rows are just a 4-digit year; they get a tinted background.
    final isYearSummary = row.payment.length == 4;

    final style = TextStyle(
      fontSize: 13,
      fontWeight: isYearSummary ? FontWeight.w700 : FontWeight.w400,
      color: scheme.onSurface,
    );

    return Container(
      color: isYearSummary
          ? scheme.primaryContainer.withValues(alpha: 0.45)
          : Colors.transparent,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg, vertical: AppSpace.md),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(row.payment, style: style)),
          Expanded(
              flex: 3,
              child: Text(row.interest,
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 3,
              child: Text(row.principal,
                  textAlign: TextAlign.right, style: style)),
          Expanded(
              flex: 3,
              child:
                  Text(row.balance, textAlign: TextAlign.right, style: style)),
        ],
      ),
    );
  }
}
