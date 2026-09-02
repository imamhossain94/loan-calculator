import 'package:flutter/material.dart';
import 'package:loan_calculator/theme/app_theme.dart';
import 'package:loan_calculator/utils/constant.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] externally; reports failure in-app instead of throwing.
Future<void> openLink(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  var ok = false;
  try {
    ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (_) {
    ok = false;
  }
  if (!ok && context.mounted) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('Could not open $url')));
  }
}

/// Yes/No confirmation. Returns false when dismissed.
Future<bool> confirm(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Delete',
  bool destructive = true,
}) async {
  final scheme = Theme.of(context).colorScheme;
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: Icon(
        destructive ? Icons.warning_amber_rounded : Icons.help_outline_rounded,
        color: destructive ? scheme.error : scheme.primary,
      ),
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          style: destructive
              ? FilledButton.styleFrom(
                  backgroundColor: scheme.error,
                  foregroundColor: scheme.onError,
                  minimumSize: const Size(0, 44),
                )
              : FilledButton.styleFrom(minimumSize: const Size(0, 44)),
          onPressed: () => Navigator.pop(context, true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Star rating prompt. 4-5 stars sends the user to the Play listing; 1-3 just
/// thanks them, so nobody is pushed to leave a bad public review.
Future<void> showRatingSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _RatingSheet(parentContext: context),
  );
}

class _RatingSheet extends StatefulWidget {
  const _RatingSheet({required this.parentContext});
  final BuildContext parentContext;

  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  int _hovered = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpace.xl, 0, AppSpace.xl, AppSpace.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Enjoying $appName?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpace.sm),
            Text(
              'Tap a star to rate the app.',
              style: TextStyle(fontSize: 14, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpace.xl),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 1; i <= 5; i++)
                  IconButton(
                    iconSize: 38,
                    onPressed: () => _submit(i),
                    onHover: (h) => setState(() => _hovered = h ? i : 0),
                    icon: Icon(
                      i <= _hovered
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: i <= _hovered ? Colors.amber : scheme.outline,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpace.sm),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Not now'),
            ),
          ],
        ),
      ),
    );
  }

  void _submit(int stars) {
    Navigator.pop(context);
    final ctx = widget.parentContext;
    if (!ctx.mounted) return;
    if (stars >= 4) {
      openLink(ctx, appLink);
    } else {
      ScaffoldMessenger.of(ctx)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Thanks for the feedback!')),
        );
    }
  }
}

/// About sheet: version, developer, credits, links.
Future<void> showAboutSheet(BuildContext context) async {
  final info = await PackageInfo.fromPlatform();
  if (!context.mounted) return;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      final scheme = Theme.of(sheetContext).colorScheme;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpace.lg, 0, AppSpace.lg, AppSpace.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpace.xs),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: scheme.primaryContainer,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(Icons.calculate_rounded,
                          color: scheme.onPrimaryContainer),
                    ),
                    const SizedBox(width: AppSpace.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            appName,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Version ${info.version} (${info.buildNumber})',
                            style: TextStyle(
                              fontSize: 13,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpace.lg),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_outline_rounded),
                title: const Text('Developer'),
                subtitle: const Text(developerName),
              ),
              ListTile(
                leading: const Icon(Icons.brush_outlined),
                title: const Text('Design'),
                subtitle: const Text(designerName),
              ),
              ListTile(
                leading: const Icon(Icons.lock_outline_rounded),
                title: const Text('Privacy'),
                subtitle: const Text(
                    'Works entirely offline. No account, no tracking, and no '
                    'device permissions are requested.'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.mail_outline_rounded),
                title: const Text('Send feedback'),
                onTap: () => openLink(sheetContext, feedbackMail),
              ),
              ListTile(
                leading: const Icon(Icons.apps_rounded),
                title: const Text('More apps'),
                onTap: () => openLink(sheetContext, storeLink),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Generic single-choice picker used for savings frequency etc.
Future<T?> pickOption<T>(
  BuildContext context, {
  required String title,
  required List<(String, T)> options,
  T? selected,
}) {
  return showModalBottomSheet<T>(
    context: context,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpace.xl, 0, AppSpace.xl, AppSpace.sm),
            child: Text(
              title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
          ),
          RadioGroup<T>(
            groupValue: selected,
            onChanged: (v) => Navigator.pop(context, v),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final (label, value) in options)
                  RadioListTile<T>(value: value, title: Text(label)),
              ],
            ),
          ),
          const SizedBox(height: AppSpace.sm),
        ],
      ),
    ),
  );
}
