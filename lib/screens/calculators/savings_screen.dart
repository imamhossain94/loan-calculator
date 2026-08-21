import 'package:flutter/material.dart';
import 'package:loan_calculator/domain/loan_math.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/dialogs.dart';
import 'package:loan_calculator/ui/widgets.dart';
import 'package:screenshot/screenshot.dart';

class SavingsScreen extends StatefulWidget {
  static const String route = '/savings';
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
  static const _frequencies = <(String, int)>[
    ('Weekly', 7),
    ('Bi-weekly', 14),
    ('Monthly', 30),
    ('Quarterly', 91),
    ('Annually', 365),
  ];

  final _shot = ScreenshotController();
  final _principal = TextEditingController(text: '1000');
  final _contribution = TextEditingController(text: '100');
  final _rate = TextEditingController(text: '5');
  final _years = TextEditingController(text: '10');
  int _everyDays = 30;

  @override
  void initState() {
    super.initState();
    for (final c in [_principal, _contribution, _rate, _years]) {
      c.addListener(() => setState(() {}));
    }
  }

  @override
  void dispose() {
    for (final c in [_principal, _contribution, _rate, _years]) {
      c.dispose();
    }
    super.dispose();
  }

  String get _frequencyLabel =>
      _frequencies.firstWhere((f) => f.$2 == _everyDays).$1;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Years are capped so the day-by-day compounding loop stays instant.
    final years = intOf(_years).clamp(0, 60);
    final r = calculateSavings(
      principal: numOf(_principal),
      contribution: numOf(_contribution),
      annualRatePercent: numOf(_rate),
      years: years,
      contributionEveryDays: _everyDays,
    );

    return CalculatorPage(
      title: 'Savings',
      actions: [ShareResultButton(controller: _shot, fileName: 'savings')],
      children: [
        Screenshot(
          controller: _shot,
          child: ResultCard(
            accent: const Color(0xFF0B7285),
            headlineLabel: 'Balance after $years years',
            headlineValue: money(r.futureValue),
            rows: [
              ('Total contributed', money(r.totalContributed)),
              ('Interest earned', money(r.interestEarned)),
              ('Contributions', '${money(numOf(_contribution))} $_frequencyLabel'),
            ],
          ),
        ),
        InputSection(
          title: 'DETAILS',
          children: [
            ValueField(
                label: 'Starting amount',
                controller: _principal,
                unit: '\$'),
            ValueField(
                label: 'Regular contribution',
                controller: _contribution,
                unit: '\$'),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpace.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: AppSpace.xs, bottom: AppSpace.xs),
                    child: Text('Contribution frequency',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: scheme.onSurfaceVariant)),
                  ),
                  Material(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: _pickFrequency,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSpace.lg, vertical: AppSpace.lg),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(_frequencyLabel,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                            ),
                            Icon(Icons.expand_more_rounded,
                                color: scheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ValueField(
                label: 'Annual interest rate', controller: _rate, unit: '%'),
            ValueField(
              label: 'Time period',
              controller: _years,
              unit: 'yr',
              helper: intOf(_years) > 60 ? 'Capped at 60 years' : null,
            ),
          ],
        ),
        const SizedBox(height: AppSpace.lg),
        ActionBar(
          primaryLabel: 'Share result',
          onPrimary: () => shareWidgetShot(context, _shot, 'savings'),
          onSecondary: () {
            _principal.text = '0';
            _contribution.text = '0';
            _rate.text = '0';
            _years.text = '0';
          },
        ),
      ],
    );
  }

  Future<void> _pickFrequency() async {
    final picked = await pickOption<int>(
      context,
      title: 'Contribution frequency',
      options: _frequencies,
      selected: _everyDays,
    );
    if (picked != null && mounted) setState(() => _everyDays = picked);
  }
}
