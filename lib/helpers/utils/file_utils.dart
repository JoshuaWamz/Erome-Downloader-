import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:gal/gal.dart';
import 'erome_utils.dart';

class FileUtils {
  static Future<Directory> getAppTempDir() async {
    final dir = await getTemporaryDirectory();
    final tempDir = Directory('${dir.path}/EromeTemp');
    if (!await tempDir.exists()) {
      await tempDir.create(recursive: true);
    }
    return tempDir;
  }

  static Future<void> saveToGallery(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return;

    // Check and request storage permission for Android (handled by gal)
    if (!await Gal.hasAccess()) {
      final granted = await Gal.requestAccess();
      if (!granted) throw Exception('Storage permission denied');
    }

    try {
      if (filePath.endsWith('.mp4') || filePath.endsWith('.mov')) {
        await Gal.putVideo(filePath, album: 'Erome');
      } else {
        await Gal.putImage(filePath, album: 'Erome');
      }
    } on GalException catch (e) {
      throw Exception('Failed to save to gallery: ${e.type.message}');
    }
  }

  static String generateFileName(String url, String albumId, int index) {
    final uri = Uri.parse(url);
    final extension = uri.path.split('.').last;
    return '${EromeUtils.sanitizeFilename(albumId)}_$index.$extension';
  }
}
