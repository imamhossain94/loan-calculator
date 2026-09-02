import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/domain/mortgage.dart';
import 'package:loan_calculator/main.dart';
import 'package:loan_calculator/models/history.dart';
import 'package:loan_calculator/models/mortgage_data.dart';
import 'package:loan_calculator/screens/history_screen.dart';
import 'package:loan_calculator/screens/result_screen.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';

class AdvancedLoanScreen extends StatefulWidget {
  static const String route = '/advanced-loan';
  const AdvancedLoanScreen({super.key});

  @override
  State<AdvancedLoanScreen> createState() => _AdvancedLoanScreenState();
}

class _AdvancedLoanScreenState extends State<AdvancedLoanScreen> {
  final _homeValue = TextEditingController(text: '300000');
  final _downPayment = TextEditingController(text: '60000');
  final _rate = TextEditingController(text: '3.5');
  final _months = TextEditingController(text: '360');
  final _propertyTax = TextEditingController(text: '2400');
  final _insurance = TextEditingController(text: '1000');
  final _pmi = TextEditingController(text: '0.85');

  /// true => deposit entered in dollars, false => entered as a percentage.
  bool _depositIsCash = true;

  List<TextEditingController> get _all => [
        _homeValue,
        _downPayment,
        _rate,
        _months,
        _propertyTax,
        _insurance,
        _pmi,
      ];

  @override
  void initState() {
    super.initState();
    for (final c in _all) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in _all) {
      c.dispose();
    }
    super.dispose();
  }

  double get _loanAmount => loanAmountFor(
        homeValue: numOf(_homeValue),
        downPayment: numOf(_downPayment),
        downPaymentIsCash: _depositIsCash,
      );

  bool get _showPmi => pmiApplies(
        homeValue: numOf(_homeValue),
        downPayment: numOf(_downPayment),
        downPaymentIsCash: _depositIsCash,
      );

  MortgageData _inputs() => MortgageData(
        homeValue: numOf(_homeValue),
        downPayment: numOf(_downPayment),
        loanAmount: _loanAmount,
        loanTerm: numOf(_months),
        homeIns: numOf(_insurance),
        interest: numOf(_rate),
        propertyTax: numOf(_propertyTax),
        pmi: numOf(_pmi),
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final outcome = calculateMortgage(input: _inputs(), showPmi: _showPmi);
    final result = outcome.resultData;

    return CalculatorPage(
      title: 'Advanced Loan',
      actions: [
        IconButton(
          tooltip: 'Saved calculations',
          icon: const Icon(Icons.history_rounded),
          onPressed: _openHistory,
        ),
      ],
      bottomBar: ActionBar(
        primaryLabel: 'View full schedule',
        onPrimary: numOf(_months) > 0 ? _showSchedule : null,
        secondaryLabel: 'Save',
        onSecondary: numOf(_months) > 0 ? _save : null,
      ),
      children: [
        ResultCard(
          accent: const Color(0xFF0CA678),
          headlineLabel: 'Monthly payment (PITI)',
          headlineValue: result.monthlyPayment ?? '--',
          rows: [
            ('Loan amount', money(_loanAmount)),
            ('Total interest', result.totalInterest ?? '--'),
            ('Payoff date', result.lastPayment ?? '--'),
            ('Monthly property tax', result.monthlyTax ?? '--'),
            ('Monthly insurance', result.monthlyIns ?? '--'),
            if (_showPmi) ('Monthly PMI', result.monthlyPmi ?? '--'),
          ],
          footnote: _showPmi
              ? 'PMI applies while the deposit is under 20% of the value.'
              : null,
        ),
        InputSection(
          title: 'PROPERTY',
          children: [
            ValueField(
                label: 'Home value / property price',
                controller: _homeValue,
                unit: '\$'),
            ValueField(
              label: 'Money down / equity',
              controller: _downPayment,
              unit: _depositIsCash ? '\$' : '%',
              onUnitTap: () => setState(() => _depositIsCash = !_depositIsCash),
              helper: 'Tap the unit to switch between \$ and %',
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: AppSpace.xs, bottom: AppSpace.md),
              child: Row(
                children: [
                  Icon(Icons.calculate_outlined,
                      size: 16, color: scheme.onSurfaceVariant),
                  const SizedBox(width: AppSpace.sm),
                  Text(
                    'Loan amount: ${money(_loanAmount)}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        InputSection(
          title: 'LOAN TERMS',
          children: [
            ValueField(label: 'Interest rate', controller: _rate, unit: '%'),
            ValueField(label: 'Loan term', controller: _months, unit: 'mo'),
          ],
        ),
        InputSection(
          title: 'ONGOING COSTS',
          children: [
            ValueField(
                label: 'Property tax per year',
                controller: _propertyTax,
                unit: '\$'),
            ValueField(
                label: 'Insurance per year',
                controller: _insurance,
                unit: '\$'),
            ValueField(
              label: 'PMI rate',
              controller: _pmi,
              unit: '%',
              enabled: _showPmi,
              helper: _showPmi
                  ? null
                  : 'Not required with a deposit of 20% or more',
            ),
          ],
        ),
      ],
    );
  }

  void _showSchedule() {
    final outcome = calculateMortgage(input: _inputs(), showPmi: _showPmi);
    Navigator.pushNamed(context, ResultScreen.route, arguments: {
      'history': History(
        mortgageData: outcome.mortgageData,
        resultData: outcome.resultData,
        calculationDate: _stamp(),
      ),
      'schedule': outcome.schedule,
    });
  }

  String _stamp() => DateFormat.yMMMd().add_jm().format(DateTime.now());

  Future<void> _save() async {
    final outcome = calculateMortgage(input: _inputs(), showPmi: _showPmi);
    final entry = History(
      mortgageData: outcome.mortgageData,
      resultData: outcome.resultData,
      calculationDate: _stamp(),
    );
    // The box is opened once in main() and stays open for the app's lifetime.
    await Hive.box(historyBox).add(entry);
    if (!mounted) return;
    showSnack(context, 'Calculation saved');
  }

  Future<void> _openHistory() async {
    final picked = await Navigator.pushNamed(context, HistoryScreen.route);
    if (picked is! History || !mounted) return;
    final m = picked.mortgageData;
    if (m == null) return;

    setState(() {
      _depositIsCash = true;
      _homeValue.text = (m.homeValue ?? 0).toString();
      _downPayment.text = (m.downPayment ?? 0).toString();
      _rate.text = (m.interest ?? 0).toString();
      _months.text = (m.loanTerm ?? 0).toString();
      _propertyTax.text = (m.propertyTax ?? 0).toString();
      _insurance.text = (m.homeIns ?? 0).toString();
      _pmi.text = (m.pmi ?? 0).toString();
    });
    showSnack(context, 'Loaded saved calculation');
  }
}
