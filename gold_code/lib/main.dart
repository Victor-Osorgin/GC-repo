import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:back_button_interceptor/back_button_interceptor.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {

  InAppWebViewController webView;
  String url = "";
  double progress = 0;

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }


  // Кнопка 'назад' Android
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    if (webView != null) {
      webView.goBack();
    }
    return true;
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(8.0),
          child: AppBar(
            backgroundColor: (Colors.black),
          ),
        ),
        body: Container(
            color: Color.fromRGBO(229, 229, 229, 1),
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(0.0),
                  child: progress < 1.0
                      ? LinearProgressIndicator(value: progress)
                      : Container()),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(0.0),
                  child: InAppWebView(

                    initialUrl: "https://shop.zolotoykod.ru/",
                    initialHeaders: {},
                   // onLongPressHitTestResult: (){},
                    initialOptions: InAppWebViewGroupOptions(
                        crossPlatform: InAppWebViewOptions(
                          debuggingEnabled: true,
                        )
                    ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      webView = controller;
                    },
                    onLoadStart: (InAppWebViewController controller, String url) {
                      setState(() {
                        this.url = url;
                        // call tel
                        if (url.substring(0,4) == 'tel:') {
                          UrlLauncher.launch(url);
                          webView.goBack();
                          webView.reload();

                          }
                        }
                      );
                    },
                    onLoadError: (controller, url, code, message) async {
                      //print("Не удалось загрузить страницу");
                    },

                    onLoadStop: (InAppWebViewController controller, String url) async {
                      setState(() {
                        this.url = url;
                      });
                    },
                    onProgressChanged: (InAppWebViewController controller, int progress) {
                      setState(() {
                        this.progress = progress / 100;
                      });
                    },
                  ),
                ),
              ),

              //ButtonBar(
              //  alignment: MainAxisAlignment.center,
              //  children: <Widget>[
              //    RaisedButton(
              //      color: Color.fromRGBO(246, 149, 36, 1),
              //      child: Icon(
              //        Icons.arrow_back_ios,
              //        color: Color.fromRGBO(255, 255, 255, 1),
              //      ),
              //      onPressed: () {
              //        if (webView != null) {
              //          webView.goBack();
              //        }
              //      },
              //    ),
              //    RaisedButton(
              //      color: Color.fromRGBO(246, 149, 36, 1),
              //      child: Icon(
              //        Icons.arrow_forward_ios,
              //        color: Color.fromRGBO(255, 255, 255, 1),
              //      ),
              //      onPressed: () {
              //        if (webView != null) {
              //          webView.goForward();
              //        }
              //      },
              //    ),
              //    RaisedButton(
              //      color: Color.fromRGBO(246, 149, 36, 1),
              //      child: Icon(
              //        Icons.replay,
              //        color: Color.fromRGBO(255, 255, 255, 1),
              //      ),
              //      onPressed: () {
              //        if (webView != null) {
              //          webView.reload();                       //#f69524
              //        }
              //      },
              //    ),
              //  ],
              //),
            ])),
      ),
    );
  }
}
