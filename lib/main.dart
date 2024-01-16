import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: const Color(0xFF10171f),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool webViewLoaded = false;
  int currentProgress = 0;
  String now = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10171f),
      body: Stack(
        children: [
          // WebView
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri.uri(Uri.parse('http://43.207.192.40')), // 设置WebView打开的URL
            ),
            initialSettings: InAppWebViewSettings(
              javaScriptEnabled: true,
              mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              // WebView创建完成后可以执行一些操作
            },
            onLoadStop: (controller, url){
              Future.delayed(Duration(milliseconds: 1000), (){
                webViewLoaded = true;
                setState(() {});
              });
            },
          ),
          // 启动画面
          if (!webViewLoaded)Positioned(
            top: 0,
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                color: const Color(0xFF10171f),
                child: Image.asset('assets/ais.png', fit: BoxFit.cover, width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,),
              ), // 替换为你的启动画面图片
            ),
          ),
        ],
      ),
    );
  }
}
