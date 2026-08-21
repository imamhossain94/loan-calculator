import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';

enum _Mode { monthlyCost, maxLoan }

class SimpleLoanScreen extends StatefulWidget {
  static const String route = '/simple-loan';
  const SimpleLoanScreen({super.key});

  @override
  State<SimpleLoanScreen> createState() => _SimpleLoanScreenState();
}

class _SimpleLoanScreenState extends State<SimpleLoanScreen> {
  final _shot = ScreenshotController();
  final _amount = TextEditingController(text: '20000');
  final _payment = TextEditingController(text: '400');
  final _rate = TextEditingController(text: '6.5');
  final _months = TextEditingController(text: '60');
  _Mode _mode = _Mode.monthlyCost;

  @override
  void initState() {
    super.initState();
    for (final c in [_amount, _payment, _rate, _months]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_amount, _payment, _rate, _months]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final months = numOf(_months);
    final rate = numOf(_rate);
    final isCost = _mode == _Mode.monthlyCost;

    final payment = isCost
        ? monthlyPayment(
            principal: numOf(_amount), annualRate: rate, months: months)
        : numOf(_payment);
    final principal = isCost
        ? numOf(_amount)
        : affordablePrincipal(
            payment: numOf(_payment), annualRate: rate, months: months);
    final totalPaid = payment * months;
    final totalInterest = totalPaid - principal;

    return CalculatorPage(
      title: 'Simple Loan',
      actions: [ShareResultButton(controller: _shot, fileName: 'simple_loan')],
      children: [
        SegmentedButton<_Mode>(
          segments: const [
            ButtonSegment(
                value: _Mode.monthlyCost,
                label: Text('Monthly cost'),
                icon: Icon(Icons.payments_outlined)),
            ButtonSegment(
                value: _Mode.maxLoan,
                label: Text('Max loan'),
                icon: Icon(Icons.trending_up_rounded)),
          ],
          selected: {_mode},
          onSelectionChanged: (s) => setState(() => _mode = s.first),
        ),
        const SizedBox(height: AppSpace.lg),
        Screenshot(
          controller: _shot,
          child: ResultCard(
            accent: const Color(0xFF3B5BDB),
            headlineLabel:
                isCost ? 'Monthly payment' : 'You could borrow',
            headlineValue: money(isCost ? payment : principal),
            rows: [
              if (isCost)
                ('Loan amount', money(principal))
              else
                ('Monthly payment', money(payment)),
              ('Interest rate', percent(rate)),
              ('Term', '${months.toStringAsFixed(0)} months'),
              ('Total interest', money(totalInterest)),
              ('Total repaid', money(totalPaid)),
            ],
          ),
        ),
        InputSection(
          title: 'DETAILS',
          children: [
            if (isCost)
              ValueField(
                  label: 'Loan amount', controller: _amount, unit: '\$')
            else
              ValueField(
                  label: 'Monthly payment', controller: _payment, unit: '\$'),
            ValueField(label: 'Interest rate', controller: _rate, unit: '%'),
            ValueField(label: 'Term', controller: _months, unit: 'mo'),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share result',
          onPrimary: () => shareWidgetShot(context, _shot, 'simple_loan'),
          onSecondary: () {
            _amount.text = '0';
            _payment.text = '0';
            _rate.text = '0';
            _months.text = '0';
          },
        ),
      ],
    );
  }
}
