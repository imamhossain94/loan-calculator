import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';

class TipScreen extends StatefulWidget {
  static const String route = '/tip';
  const TipScreen({super.key});

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  final _shot = ScreenshotController();
  final _bill = TextEditingController(text: '100');
  final _tip = TextEditingController(text: '15');
  final _tax = TextEditingController(text: '0');
  final _people = TextEditingController(text: '2');

  @override
  void initState() {
    super.initState();
    for (final c in [_bill, _tip, _tax, _people]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_bill, _tip, _tax, _people]) {
      c.dispose();
    }
    super.dispose();
  }

  void _reset() {
    _bill.text = '0';
    _tip.text = '15';
    _tax.text = '0';
    _people.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    final people = intOf(_people);
    final r = calculateTip(
      bill: numOf(_bill),
      tipPercent: numOf(_tip),
      taxPercent: numOf(_tax),
      people: people,
    );

    return CalculatorPage(
      title: 'Tip',
      actions: [
        ShareResultButton(
          controller: _shot,
          fileName: 'tip',
        ),
      ],
      children: [
        Screenshot(
          controller: _shot,
          child: ResultCard(
            accent: const Color(0xFFC2255C),
            headlineLabel: people > 1 ? 'Each person pays' : 'Total to pay',
            headlineValue: money(people > 1 ? r.perPerson : r.total),
            rows: [
              ('Bill', money(numOf(_bill))),
              ('Tip (${percent(numOf(_tip), decimals: 0)})', money(r.tip)),
              if (numOf(_tax) > 0)
                ('Tax (${percent(numOf(_tax), decimals: 0)})', money(r.tax)),
              ('Total', money(r.total)),
              if (people > 1) ('Split between', '$people people'),
            ],
            footnote: people <= 0 ? 'Enter at least 1 person to split.' : null,
          ),
        ),
        InputSection(
          title: 'DETAILS',
          children: [
            ValueField(label: 'Bill amount', controller: _bill, unit: '\$'),
            ValueField(label: 'Tip', controller: _tip, unit: '%'),
            ValueField(label: 'Tax (optional)', controller: _tax, unit: '%'),
            ValueField(
                label: 'Number of people', controller: _people, unit: 'ppl'),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share result',
          onPrimary: () => shareWidgetShot(context, _shot, 'tip'),
          onSecondary: _reset,
        ),
      ],
    );
  }
}
