import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';

class TaxScreen extends StatefulWidget {
  static const String route = '/tax';
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  final _shot = ScreenshotController();
  final _price = TextEditingController(text: '100');
  final _rate = TextEditingController(text: '7.5');

  @override
  void initState() {
    super.initState();
    for (final c in [_price, _rate]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    _price.dispose();
    _rate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = calculateTax(price: numOf(_price), ratePercent: numOf(_rate));

    return CalculatorPage(
      title: 'Sales Tax',
      actions: [ShareResultButton(controller: _shot, fileName: 'tax')],
      children: [
        Screenshot(
          controller: _shot,
          child: ResultCard(
            accent: const Color(0xFFE8590C),
            headlineLabel: 'Total price',
            headlineValue: money(r.total),
            rows: [
              ('Price before tax', money(numOf(_price))),
              ('Tax (${percent(numOf(_rate))})', money(r.tax)),
            ],
          ),
        ),
        InputSection(
          title: 'DETAILS',
          children: [
            ValueField(label: 'Price', controller: _price, unit: '\$'),
            ValueField(label: 'Tax rate', controller: _rate, unit: '%'),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share result',
          onPrimary: () => shareWidgetShot(context, _shot, 'tax'),
          onSecondary: () {
            _price.text = '0';
            _rate.text = '0';
          },
        ),
      ],
    );
  }
}
