// ignore: avoid_web_libraries_in_flutter
// import 'dart:html' as html;

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

/// Utility for saving files locally and sharing them.
/// Works across:
/// - Android / iOS
/// - Windows / macOS / Linux
/// - Web (download only)
class FileExportHelper {
  /// Save a file and open share sheet
  static Future<void> saveAndShareFile({
    required String fileName,
    required String content,
  }) async {
    // if (kIsWeb) {
    //   // 🌐 Web: trigger browser download
    //   await _downloadForWeb(fileName, content);
    //   return;
    // }

    // 📂 Mobile/Desktop: write to file system
    final file = await _writeToFile(fileName, content);

    // 📤 Open native share sheet
    await SharePlus.instance.share(
      ShareParams(
        text: "Exported Postman Collection",
        files: [XFile(file.path)],
      ),
    );
  }

  // ============================================================
  // Write file to platform-appropriate directory
  // ============================================================
  static Future<File> _writeToFile(String fileName, String content) async {
    Directory directory;

    if (Platform.isAndroid) {
      // Android: app documents directory
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isIOS) {
      // iOS: app documents directory
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      // Desktop: downloads directory if available
      directory =
          (await getDownloadsDirectory()) ??
          await getApplicationDocumentsDirectory();
    } else {
      // Fallback
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);

    await file.writeAsString(content, flush: true);
    return file;
  }

  // ============================================================
  // Web download
  // ============================================================
  // static Future<void> _downloadForWeb(String fileName, String content) async {
  //   final bytes = Uint8List.fromList(content.codeUnits);
  //   final blob = html.Blob([bytes]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);

  //   final anchor =
  //       html.AnchorElement(href: url)
  //         ..setAttribute('download', fileName)
  //         ..click();

  //   html.Url.revokeObjectUrl(url);
  // }
}
