import 'package:aispace/utils/screenshotUtil.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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


  void createScreenshot() {
    RepaintBoundaryUtils().savePhoto();
  }

  JavascriptChannel _alertJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'AISToast',
        onMessageReceived: (JavascriptMessage message) {
          switch (message.message){
            case "createScreenshot" : {
              createScreenshot();
              break;
            }
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF10171f),
      body: RepaintBoundary(
        key: boundaryKey,
        child: Stack(
          children: [
            // WebView
            WebView(
              initialUrl: 'http://18.162.207.126', // 设置你要加载的初始网址
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                // WebView 加载完毕后，设置 webViewLoaded 为 true
                Future.delayed(const Duration(milliseconds: 1000), (){
                  webViewLoaded = true;
                  setState(() {});
                });
              },
              javascriptChannels:  <JavascriptChannel>{
                _alertJavascriptChannel(context)
              },
            ),
            // 启动画面
            if(!webViewLoaded) Positioned(
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
      ),
    );
  }
}
