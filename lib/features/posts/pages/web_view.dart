import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CustomWebView extends StatefulWidget {
  final String videoUrl;

  const CustomWebView({super.key, required this.videoUrl});

  @override
  _CustomWebViewState createState() => _CustomWebViewState();
}

class _CustomWebViewState extends State<CustomWebView> {
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.videoUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }
}

Widget buildVideoWidget(String embedText) {
  // Check if the embedText contains a valid video URL.
  String? urlChange;
  if (embedText.contains('src="')) {
    urlChange = embedText.split('src="')[1].split('"')[0];
  } else {
    urlChange = embedText;
  }

  if (urlChange.contains("http")==true) {
    return SizedBox(
      width: double.infinity,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CustomWebView(videoUrl: urlChange!),
      ),
    );
  }
  return SizedBox();
}
