import 'package:flutter/material.dart';
import 'package:loan_calculator/screens/calculators/advanced_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/compare_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/discount_screen.dart';
import 'package:loan_calculator/screens/calculators/savings_screen.dart';
import 'package:loan_calculator/screens/calculators/simple_loan_screen.dart';
import 'package:loan_calculator/screens/calculators/tax_screen.dart';
import 'package:loan_calculator/screens/calculators/tip_screen.dart';
import 'package:loan_calculator/service/share_service.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/ui/dialogs.dart';
import 'package:loan_calculator/utils/constant.dart';

class _Tool {
  const _Tool(this.icon, this.title, this.subtitle, this.route, this.color);
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;
  final Color color;
}

class HomeScreen extends StatelessWidget {
  static const String route = '/';

  const HomeScreen({super.key});

  static const _loans = [
    _Tool(Icons.request_quote_outlined, 'Simple Loan',
        'Monthly cost or max loan', SimpleLoanScreen.route, Color(0xFF3B5BDB)),
    _Tool(Icons.account_balance_outlined, 'Advanced Loan',
        'Full amortization schedule', AdvancedLoanScreen.route,
        Color(0xFF0CA678)),
    _Tool(Icons.balance_outlined, 'Compare Loan', 'Up to 3 offers side by side',
        CompareLoanScreen.route, Color(0xFF1C7ED6)),
  ];

  static const _everyday = [
    _Tool(Icons.savings_outlined, 'Savings', 'Growth with contributions',
        SavingsScreen.route, Color(0xFF0B7285)),
    _Tool(Icons.receipt_long_outlined, 'Sales Tax', 'Tax and total price',
        TaxScreen.route, Color(0xFFE8590C)),
    _Tool(Icons.local_offer_outlined, 'Discount', 'Savings and final price',
        DiscountScreen.route, Color(0xFF9C36B5)),
    _Tool(Icons.restaurant_outlined, 'Tip', 'Split a bill fairly',
        TipScreen.route, Color(0xFFC2255C)),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            tooltip: 'Share this app',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => ShareService.shareText(
              'Check out $appName - a free, offline loan and finance '
              'calculator.\n$appLink',
            ),
          ),
          IconButton(
            tooltip: 'About',
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: () => showAboutSheet(context),
          ),
          const SizedBox(width: AppSpace.xs),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpace.lg, AppSpace.md, AppSpace.lg, AppSpace.xxl),
          children: [
            const _SectionLabel('Loans'),
            for (final t in _loans) _ToolTile(tool: t),
            const SizedBox(height: AppSpace.xl),
            const _SectionLabel('Everyday'),
            for (final t in _everyday) _ToolTile(tool: t),
            const SizedBox(height: AppSpace.xl),
            const _SectionLabel('More'),
            _PlainTile(
              icon: Icons.star_outline_rounded,
              title: 'Rate the app',
              onTap: () => showRatingSheet(context),
            ),
            _PlainTile(
              icon: Icons.mail_outline_rounded,
              title: 'Send feedback',
              onTap: () => openLink(context, feedbackMail),
            ),
            _PlainTile(
              icon: Icons.apps_rounded,
              title: 'More apps by the developer',
              onTap: () => openLink(context, storeLink),
            ),
            const SizedBox(height: AppSpace.xl),
            Center(
              child: Text(
                'Works offline · No permissions · No tracking',
                style: TextStyle(
                  fontSize: 12,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md, left: AppSpace.xs),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({required this.tool});
  final _Tool tool;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, tool.route),
          child: Padding(
            padding: const EdgeInsets.all(AppSpace.lg),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: tool.color,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Icon(tool.icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: AppSpace.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tool.subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: scheme.outline),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlainTile extends StatelessWidget {
  const _PlainTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.sm),
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: scheme.onSurfaceVariant),
          title: Text(title, style: const TextStyle(fontSize: 15)),
          trailing:
              Icon(Icons.chevron_right_rounded, color: scheme.outline),
          onTap: onTap,
        ),
      ),
    );
  }
}
