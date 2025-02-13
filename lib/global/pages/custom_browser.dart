import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart'; // Import the services package

class CustomBrowser extends StatefulWidget {
  final String url;

  const CustomBrowser({super.key, required this.url});

  @override
  _CustomBrowserState createState() => _CustomBrowserState();
}

class _CustomBrowserState extends State<CustomBrowser> {
  String? title;
  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(
        JavaScriptMode.unrestricted,
      ).then((_) {
        _controller.getTitle().then((v) {
          setState(() {
            title = v;
          });
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? 'Browser'),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.white),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _controller.reload();
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Colors.white),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: widget.url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Link copied to clipboard')),
              );
            },
          ),
        ],
      ),
      body: WebViewWidget(
        controller: _controller,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Forward',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              _controller.goBack();
              break;
            case 1:
              _controller.goForward();
              break;
            case 2:
              _controller.loadRequest(Uri.parse(widget.url));
              break;
          }
        },
      ),
    );
  }
}
