import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loan_calculator/theme/app_theme.dart';

/// A labelled numeric input. One shared field for every calculator, so the
/// inputs look and behave identically across the app.
class ValueField extends StatelessWidget {
  const ValueField({
    super.key,
    required this.label,
    required this.controller,
    this.unit,
    this.hint = '0',
    this.helper,
    this.onUnitTap,
    this.enabled = true,
  });

  final String label;
  final TextEditingController controller;

  /// Trailing unit shown inside the field, e.g. `$`, `%`, `mo`.
  final String? unit;
  final String hint;
  final String? helper;

  /// When set, the unit becomes a tappable toggle (used for $ / % switches).
  final VoidCallback? onUnitTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget? suffix;
    if (unit != null) {
      final chip = Container(
        margin: const EdgeInsets.only(right: AppSpace.sm),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpace.md, vertical: AppSpace.xs),
        decoration: BoxDecoration(
          color: onUnitTap != null
              ? scheme.primaryContainer
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          unit!,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: onUnitTap != null
                ? scheme.onPrimaryContainer
                : scheme.onSurfaceVariant,
          ),
        ),
      );
      suffix = onUnitTap == null
          ? chip
          : InkWell(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              onTap: onUnitTap,
              child: chip,
            );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: AppSpace.xs, bottom: AppSpace.xs),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          TextField(
            controller: controller,
            enabled: enabled,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
            ],
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              hintText: hint,
              helperText: helper,
              suffixIcon: suffix,
              suffixIconConstraints: const BoxConstraints(minWidth: 0),
            ),
          ),
        ],
      ),
    );
  }
}

/// The headline card at the top of each calculator: one hero figure plus
/// supporting rows.
class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.headlineLabel,
    required this.headlineValue,
    this.rows = const [],
    this.accent,
    this.footnote,
  });

  final String headlineLabel;
  final String headlineValue;
  final List<(String, String)> rows;
  final Color? accent;
  final String? footnote;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = accent ?? scheme.primary;
    final fg = accent != null ? Colors.white : scheme.onPrimary;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpace.xl),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headlineLabel.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
              color: fg.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: AppSpace.xs),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              headlineValue,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: fg,
              ),
            ),
          ),
          if (rows.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpace.lg),
              child: Divider(color: fg.withValues(alpha: 0.25), height: 1),
            ),
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpace.sm),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: TextStyle(
                          fontSize: 14,
                          color: fg.withValues(alpha: 0.8),
                        ),
                      ),
                    ),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: fg,
                      ),
                    ),
                  ],
                ),
              ),
          ],
          if (footnote != null) ...[
            const SizedBox(height: AppSpace.sm),
            Text(
              footnote!,
              style: TextStyle(
                fontSize: 12,
                color: fg.withValues(alpha: 0.75),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Groups related inputs under a small heading.
class InputSection extends StatelessWidget {
  const InputSection({super.key, this.title, required this.children});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.only(
                top: AppSpace.xl, bottom: AppSpace.md, left: AppSpace.xs),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ...children,
      ],
    );
  }
}

/// Calculate / Reset pair pinned under the form.
class ActionBar extends StatelessWidget {
  const ActionBar({
    super.key,
    required this.primaryLabel,
    required this.onPrimary,
    this.secondaryLabel = 'Reset',
    this.onSecondary,
  });

  final String primaryLabel;
  final VoidCallback? onPrimary;
  final String secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onSecondary != null) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: onSecondary,
              child: Text(secondaryLabel),
            ),
          ),
          const SizedBox(width: AppSpace.md),
        ],
        Expanded(
          flex: 2,
          child: FilledButton(
            onPressed: onPrimary,
            child: Text(primaryLabel),
          ),
        ),
      ],
    );
  }
}

/// Consistent page shell: edge-to-edge safe area, standard app bar, scrolling
/// body with uniform padding.
class CalculatorPage extends StatelessWidget {
  const CalculatorPage({
    super.key,
    required this.title,
    required this.children,
    this.actions = const [],
    this.bottomBar,
  });

  final String title;
  final List<Widget> children;
  final List<Widget> actions;
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
              AppSpace.lg, AppSpace.sm, AppSpace.lg, AppSpace.xxl),
          children: children,
        ),
      ),
      bottomNavigationBar: bottomBar == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpace.lg, AppSpace.sm, AppSpace.lg, AppSpace.lg),
                child: bottomBar,
              ),
            ),
    );
  }
}

/// A single label/value line used inside surface cards.
class DetailRow extends StatelessWidget {
  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.emphasise = false,
  });

  final String label;
  final String value;
  final bool emphasise;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpace.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: scheme.onSurfaceVariant,
                fontWeight: emphasise ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(width: AppSpace.md),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: emphasise ? FontWeight.w700 : FontWeight.w600,
              color: emphasise ? scheme.primary : scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Rounded surface container used to group detail rows.
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ??
          const EdgeInsets.symmetric(
              horizontal: AppSpace.lg, vertical: AppSpace.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: child,
    );
  }
}

/// Empty-state placeholder.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
  });

  final IconData icon;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpace.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: scheme.onSurfaceVariant),
            const SizedBox(height: AppSpace.lg),
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: scheme.onSurface,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpace.sm),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void showSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

/// Parses a controller's text, treating blank/garbage as 0.
double numOf(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

int intOf(TextEditingController c) => int.tryParse(c.text.trim()) ?? 0;
