import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebPageScreen extends StatefulWidget {
  final String title;
  final String url;

  const CommonWebPageScreen({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<CommonWebPageScreen> createState() => _CommonWebPageScreenState();
}

class _CommonWebPageScreenState extends State<CommonWebPageScreen> {
  late final WebViewController controller;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int p) {
            setState(() => progress = p / 100);
          },
          onPageStarted: (String url) {

          },
          onPageFinished: (String url) {
  
          },
          onWebResourceError: (WebResourceError error) {

          },
          onNavigationRequest: (NavigationRequest request) {
            // ✅ Allow both HTTP and HTTPS for sites like PGTI
            if (request.url.startsWith('http://') ||
                request.url.startsWith('https://')) {
              return NavigationDecision.navigate;
            }
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.url),
        headers: {
          // ✅ Custom User-Agent to avoid blocking
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
              "(KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36",
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Check if WebView can go back
            controller.canGoBack().then((canGoBack) {
              if (canGoBack) {
                controller.goBack();
              } else {
                Navigator.pop(context);
              }
            });
          },
        ),
      ),
      body: Column(
        children: [
          // ✅ Smooth progress bar for page load
          if (progress < 1.0)
            LinearProgressIndicator(
              value: progress,
              color: Colors.green,
              backgroundColor: Colors.grey.shade300,
            ),
          Expanded(child: WebViewWidget(controller: controller)),
        ],
      ),
    );
  }
}
