import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import '../services/download_manager.dart';
import '../helpers/managers/log_manager.dart';
import '../helpers/config.dart';

const String injectionJavaScript = '''
(function() {
  function addDownloadButton() {
    if (window.location.href.includes('/a/')) {
      var btn = document.getElementById('erome-download-btn');
      if (!btn) {
        btn = document.createElement('button');
        btn.id = 'erome-download-btn';
        btn.innerHTML = '⬇ Download';
        btn.style.position = 'fixed';
        btn.style.bottom = '20px';
        btn.style.right = '20px';
        btn.style.zIndex = '9999';
        btn.style.backgroundColor = '#4CAF50';
        btn.style.color = 'white';
        btn.style.padding = '12px 24px';
        btn.style.border = 'none';
        btn.style.borderRadius = '8px';
        btn.style.fontSize = '18px';
        btn.style.boxShadow = '0 4px 8px rgba(0,0,0,0.3)';
        btn.style.cursor = 'pointer';
        btn.onclick = function() {
          if (window.flutter_inappwebview && window.flutter_inappwebview.callHandler) {
            window.flutter_inappwebview.callHandler('downloadAlbum', window.location.href);
          } else {
            console.log('Flutter handler not available');
          }
        };
        document.body.appendChild(btn);
      }
    } else {
      var btn = document.getElementById('erome-download-btn');
      if (btn) btn.remove();
    }
  }

  addDownloadButton();
  const originalPushState = history.pushState;
  history.pushState = function() {
    originalPushState.apply(this, arguments);
    setTimeout(addDownloadButton, 100);
  };
  window.addEventListener('popstate', addDownloadButton);
})();
''';

class BrowserScreen extends StatefulWidget {
  const BrowserScreen({super.key});

  @override
  State<BrowserScreen> createState() => _BrowserScreenState();
}

class _BrowserScreenState extends State<BrowserScreen> {
  late InAppWebViewController _webViewController;
  String _currentUrl = Config.baseUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: InAppWebView(
            initialUrlRequest: URLRequest(url: WebUri(Config.baseUrl)),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              userAgent: Config.userAgent,
            ),
            onWebViewCreated: (controller) {
              _webViewController = controller;
              controller.addJavaScriptHandler(
                handlerName: 'downloadAlbum',
                callback: (args) {
                  final url = args.isNotEmpty ? args[0] as String : null;
                  if (url != null) {
                    Provider.of<DownloadManager>(context, listen: false).startDownload(url);
                  }
                },
              );
            },
            onLoadStop: (controller, url) async {
              if (url != null) {
                setState(() => _currentUrl = url.toString());
                await controller.evaluateJavascript(source: injectionJavaScript);
              }
            },
            onConsoleMessage: (controller, message) {
              Provider.of<LogManager>(context, listen: false)
                  .addLog('[WebView] ${message.message}');
            },
          ),
        ),
        Container(
          color: Colors.grey[900],
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _currentUrl,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
