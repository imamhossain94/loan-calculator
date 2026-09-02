import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';

/// Mutable input row for one loan offer.
class _OfferInputs {
  _OfferInputs(this.label, String principal, String rate, String months,
      String fees)
      : principal = TextEditingController(text: principal),
        rate = TextEditingController(text: rate),
        months = TextEditingController(text: months),
        fees = TextEditingController(text: fees);

  String label;
  final TextEditingController principal;
  final TextEditingController rate;
  final TextEditingController months;
  final TextEditingController fees;

  List<TextEditingController> get all => [principal, rate, months, fees];

  void dispose() {
    for (final c in all) {
      c.dispose();
    }
  }

  LoanOption toOption() => LoanOption(
        label: label,
        principal: double.tryParse(principal.text.trim()) ?? 0,
        annualRate: double.tryParse(rate.text.trim()) ?? 0,
        months: double.tryParse(months.text.trim()) ?? 0,
        fees: double.tryParse(fees.text.trim()) ?? 0,
      );
}

class CompareLoanScreen extends StatefulWidget {
  static const String route = '/compare-loan';
  const CompareLoanScreen({super.key});

  @override
  State<CompareLoanScreen> createState() => _CompareLoanScreenState();
}

class _CompareLoanScreenState extends State<CompareLoanScreen> {
  static const _accents = [
    Color(0xFF1C7ED6),
    Color(0xFF0CA678),
    Color(0xFFE8590C),
  ];

  final _shot = ScreenshotController();
  late final List<_OfferInputs> _offers = [
    _OfferInputs('Offer A', '250000', '6.5', '360', '0'),
    _OfferInputs('Offer B', '250000', '6.0', '360', '4000'),
  ];

  @override
  void initState() {
    super.initState();
    for (final o in _offers) {
      _attach(o);
    }
  }

  void _attach(_OfferInputs o) {
    for (final c in o.all) {
      c.addListener(_onChanged);
    }
  }

  void _onChanged() => setState(() {});

  @override
  void dispose() {
    for (final o in _offers) {
      o.dispose();
    }
    super.dispose();
  }

  void _addOffer() {
    if (_offers.length >= 3) return;
    final o = _OfferInputs(
        'Offer ${String.fromCharCode(65 + _offers.length)}',
        _offers.first.principal.text,
        '6.0',
        _offers.first.months.text,
        '0');
    _attach(o);
    setState(() => _offers.add(o));
  }

  void _removeOffer(int index) {
    final o = _offers.removeAt(index);
    o.dispose();
    // Re-letter the remaining offers so labels stay A, B, C.
    for (var i = 0; i < _offers.length; i++) {
      _offers[i].label = 'Offer ${String.fromCharCode(65 + i)}';
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final comparison =
        LoanComparison.of(_offers.map((o) => o.toOption()).toList());
    final winner = comparison.cheapest;
    final anyValid = comparison.cheapestIndex >= 0;

    return CalculatorPage(
      title: 'Compare Loan',
      actions: [ShareResultButton(controller: _shot, fileName: 'compare_loan')],
      children: [
        Screenshot(
          controller: _shot,
          child: Column(
            children: [
              ResultCard(
                accent: const Color(0xFF1C7ED6),
                headlineLabel: anyValid ? 'Best value' : 'Best value',
                headlineValue: anyValid ? winner!.label : '--',
                rows: anyValid
                    ? [
                        ('Monthly payment', money(winner!.payment)),
                        ('Total interest', money(winner.totalInterest)),
                        if (winner.fees > 0) ('Up-front fees', money(winner.fees)),
                        ('Total cost', money(winner.totalCost)),
                        if (comparison.maxSaving > 0)
                          ('Saves up to', money(comparison.maxSaving)),
                      ]
                    : const [],
                footnote: anyValid
                    ? 'Ranked by total cost: interest plus up-front fees.'
                    : 'Enter a loan amount and term to compare.',
              ),
              const SizedBox(height: AppSpace.md),
              _ComparisonTable(comparison: comparison, accents: _accents),
            ],
          ),
        ),
        for (var i = 0; i < _offers.length; i++)
          _OfferForm(
            offer: _offers[i],
            accent: _accents[i % _accents.length],
            isBest: comparison.cheapestIndex == i,
            isLowestPayment: comparison.lowestPaymentIndex == i,
            onRemove: _offers.length > 2 ? () => _removeOffer(i) : null,
          ),
        if (_offers.length < 3) ...[
          const SizedBox(height: AppSpace.sm),
          OutlinedButton.icon(
            onPressed: _addOffer,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add another offer'),
          ),
        ],
        const SizedBox(height: AppSpace.lg),
        Text(
          'Comparisons are estimates based on a fixed rate and equal monthly '
          'payments. They do not include insurance or variable-rate changes.',
          style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant),
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share comparison',
          onPrimary: () => shareWidgetShot(context, _shot, 'compare_loan'),
        ),
      ],
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.comparison, required this.accents});

  final LoanComparison comparison;
  final List<Color> accents;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final options = comparison.options;

    Widget headerCell(String text) => Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: scheme.onSurfaceVariant,
            ),
          ),
        );

    Widget valueCell(String text, {bool highlight = false, Color? color}) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: highlight ? FontWeight.w700 : FontWeight.w500,
              color: color ?? scheme.onSurface,
            ),
          ),
        );

    return SurfaceCard(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpace.lg, vertical: AppSpace.md),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - (AppSpace.lg * 4),
          ),
          child: Table(
            columnWidths: {
              0: const FlexColumnWidth(1.5),
              for (var i = 0; i < options.length; i++)
                i + 1: const FixedColumnWidth(110),
            },
            children: [
              TableRow(children: [
                headerCell(''),
                for (var i = 0; i < options.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: accents[i % accents.length],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: AppSpace.xs),
                        Text(
                          options[i].label,
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
              ]),
              _row(headerCell, valueCell, 'Monthly', options,
                  (o) => money(o.payment),
                  best: comparison.lowestPaymentIndex),
              _row(headerCell, valueCell, 'Total interest', options,
                  (o) => money(o.totalInterest)),
              _row(headerCell, valueCell, 'Fees', options,
                  (o) => money(o.fees)),
              _row(headerCell, valueCell, 'Total cost', options,
                  (o) => money(o.totalCost),
                  best: comparison.cheapestIndex),
            ],
          ),
        ),
      ),
    );
  }

  TableRow _row(
    Widget Function(String) headerCell,
    Widget Function(String, {bool highlight, Color? color}) valueCell,
    String label,
    List<LoanOption> options,
    String Function(LoanOption) value, {
    int best = -1,
  }) {
    return TableRow(children: [
      headerCell(label),
      for (var i = 0; i < options.length; i++)
        valueCell(
          options[i].isValid ? value(options[i]) : '--',
          highlight: best == i,
          color: best == i ? const Color(0xFF0CA678) : null,
        ),
    ]);
  }
}

class _OfferForm extends StatelessWidget {
  const _OfferForm({
    required this.offer,
    required this.accent,
    required this.isBest,
    required this.isLowestPayment,
    this.onRemove,
  });

  final _OfferInputs offer;
  final Color accent;
  final bool isBest;
  final bool isLowestPayment;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration:
                    BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: AppSpace.sm),
              Text(
                offer.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpace.sm),
              if (isBest)
                _Badge(
                    text: 'Best value',
                    color: const Color(0xFF0CA678))
              else if (isLowestPayment)
                _Badge(text: 'Lowest payment', color: scheme.primary),
              const Spacer(),
              if (onRemove != null)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  tooltip: 'Remove ${offer.label}',
                  icon: const Icon(Icons.close_rounded, size: 20),
                  onPressed: onRemove,
                ),
            ],
          ),
          const SizedBox(height: AppSpace.md),
          ValueField(
              label: 'Loan amount', controller: offer.principal, unit: '\$'),
          ValueField(label: 'Interest rate', controller: offer.rate, unit: '%'),
          ValueField(label: 'Term', controller: offer.months, unit: 'mo'),
          ValueField(
              label: 'Up-front fees', controller: offer.fees, unit: '\$'),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, required this.color});
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpace.sm, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700, color: color),
      ),
    );
  }
}
