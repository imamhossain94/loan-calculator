import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

/// Export helpers.
///
/// Google Play's Personal Loans policy forbids this app from holding storage,
/// contacts, location or SMS permissions, so nothing here may touch shared or
/// external storage. Everything is written to the app's own cache directory --
/// which needs no permission on any API level -- and then handed to the system
/// share sheet. The receiving app is what actually persists the file, under
/// permissions the user grants to that app.
class ShareService {
  const ShareService._();

  static Future<ShareResult> shareBytes({
    required Uint8List bytes,
    required String fileName,
    required String mimeType,
    String? subject,
    String? text,
    Rect? origin,
  }) async {
    final cacheDir = await getTemporaryDirectory();
    final exportDir = Directory('${cacheDir.path}/exports');
    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final file = File('${exportDir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);

    return SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path, mimeType: mimeType)],
        subject: subject,
        text: text,
        sharePositionOrigin: origin,
      ),
    );
  }

  static Future<ShareResult> shareImage({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    Rect? origin,
  }) {
    return shareBytes(
      bytes: bytes,
      fileName: fileName.endsWith('.png') ? fileName : '$fileName.png',
      mimeType: 'image/png',
      subject: subject,
      origin: origin,
    );
  }

  static Future<ShareResult> shareText(String text, {Rect? origin}) {
    return SharePlus.instance.share(
      ShareParams(text: text, sharePositionOrigin: origin),
    );
  }

  /// Deletes previously exported files so the cache does not grow unbounded.
  static Future<void> clearExports() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final exportDir = Directory('${cacheDir.path}/exports');
      if (await exportDir.exists()) {
        await exportDir.delete(recursive: true);
      }
    } catch (_) {
      // Best effort only -- never block startup on cache cleanup.
    }
  }
}

/// The global position of [context]'s widget, used to anchor the share popover
/// on iPad. Ignored on Android.
Rect? shareOriginOf(BuildContext context) {
  final box = context.findRenderObject() as RenderBox?;
  if (box == null || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero) & box.size;
}

/// Captures the widget wrapped by [controller] and opens the share sheet.
Future<void> shareWidgetShot(
  BuildContext context,
  ScreenshotController controller,
  String name, {
  String? subject,
}) async {
  final origin = shareOriginOf(context);
  Uint8List? bytes;
  try {
    bytes = await controller.capture(
      delay: const Duration(milliseconds: 20),
      pixelRatio: 3,
    );
  } catch (_) {
    bytes = null;
  }

  if (bytes == null) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Could not capture the result.')),
        );
    }
    return;
  }

  await ShareService.shareImage(
    bytes: bytes,
    fileName: '${name}_${DateTime.now().millisecondsSinceEpoch}.png',
    subject: subject ?? 'Calculation result',
    origin: origin,
  );
}

/// App-bar action that shares the captured result card.
class ShareResultButton extends StatelessWidget {
  const ShareResultButton({
    super.key,
    required this.controller,
    required this.fileName,
    this.subject,
  });

  final ScreenshotController controller;
  final String fileName;
  final String? subject;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Share result',
      icon: const Icon(Icons.ios_share_rounded),
      onPressed: () =>
          shareWidgetShot(context, controller, fileName, subject: subject),
    );
  }
}
