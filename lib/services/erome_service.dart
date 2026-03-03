import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import '../helpers/config.dart';
import '../helpers/managers/log_manager.dart';

class EromeService {
  final LogManager logManager;

  EromeService(this.logManager);

  Future<List<String>> fetchMediaUrls(String albumUrl) async {
    logManager.addLog('Fetching album: $albumUrl');
    final response = await http.get(
      Uri.parse(albumUrl),
      headers: {'User-Agent': Config.userAgent},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load album (${response.statusCode})');
    }

    final document = parser.parse(response.body);
    final mediaUrls = <String>[];

    // Images: <img class="img img-responsive" data-src="...">
    final images = document.querySelectorAll('img.img-responsive');
    for (var img in images) {
      final src = img.attributes['data-src'] ?? img.attributes['src'];
      if (src != null && src.startsWith('http')) {
        mediaUrls.add(src);
      }
    }

    // Videos: <video> <source src="..."> or <div class="video-preview" data-src="...">
    final videos = document.querySelectorAll('video source');
    for (var source in videos) {
      final src = source.attributes['src'];
      if (src != null && src.startsWith('http')) {
        mediaUrls.add(src);
      }
    }

    // Also check for data-src on video containers
    final videoDivs = document.querySelectorAll('div.video-preview');
    for (var div in videoDivs) {
      final src = div.attributes['data-src'];
      if (src != null && src.startsWith('http')) {
        mediaUrls.add(src);
      }
    }

    logManager.addLog('Found ${mediaUrls.length} media items');
    return mediaUrls;
  }
}
