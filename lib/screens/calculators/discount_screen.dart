import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';

class DiscountScreen extends StatefulWidget {
  static const String route = '/discount';
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final _shot = ScreenshotController();
  final _price = TextEditingController(text: '100');
  final _discount = TextEditingController(text: '20');
  final _tax = TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
    for (final c in [_price, _discount, _tax]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_price, _discount, _tax]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = calculateDiscount(
      price: numOf(_price),
      discountPercent: numOf(_discount),
      taxPercent: numOf(_tax),
    );

    return CalculatorPage(
      title: 'Discount',
      actions: [ShareResultButton(controller: _shot, fileName: 'discount')],
      children: [
        Screenshot(
          controller: _shot,
          child: ResultCard(
            accent: const Color(0xFF9C36B5),
            headlineLabel: 'You pay',
            headlineValue: money(r.finalPrice),
            rows: [
              ('Original price', money(numOf(_price))),
              if (numOf(_tax) > 0)
                ('Tax (${percent(numOf(_tax), decimals: 0)})',
                    money(r.taxAmount)),
              ('You save', money(r.saved)),
            ],
          ),
        ),
        InputSection(
          title: 'DETAILS',
          children: [
            ValueField(label: 'Original price', controller: _price, unit: '\$'),
            ValueField(label: 'Discount', controller: _discount, unit: '%'),
            ValueField(label: 'Tax (optional)', controller: _tax, unit: '%'),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share result',
          onPrimary: () => shareWidgetShot(context, _shot, 'discount'),
          onSecondary: () {
            _price.text = '0';
            _discount.text = '0';
            _tax.text = '0';
          },
        ),
      ],
    );
  }
}
