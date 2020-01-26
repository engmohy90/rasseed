import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:rasseed/screens/my_cards/Cart_screen.dart';
import 'package:rasseed/screens/my_cards/Fail_Payfort.dart';
import 'package:rasseed/screens/my_cards/Sccess%D9%80Payfort.dart';

class GetCurrentURLWebView extends StatefulWidget {
  final String selectedUrl;
  @override
  GetCurrentURLWebViewState createState() {
    return new GetCurrentURLWebViewState(selectedUrl);
  }
  GetCurrentURLWebView({
    @required this.selectedUrl,
  });

}

class GetCurrentURLWebViewState extends State<GetCurrentURLWebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  StreamSubscription<String> _onUrlChanged;

  var selectedUrl_1;
  String _title = "... جاري التحميل ";
  GetCurrentURLWebViewState(String selectedUrl){
     selectedUrl_1 = selectedUrl;
  }


  @override
  void initState() {
    super.initState();

    flutterWebviewPlugin.onStateChanged.listen((state) async {
      if (state.type != WebViewState.finishLoad) {
        print("Loading");


        setState(() {
          _title = "... جاري التحميل ";
        });
      }else{
        setState(() {
          _title = "اكمال الدفع";
        });
      }
    });

    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (mounted) {
        print("Current URL: $url");
        if(url == "https://www.rasseed.com/fail"){
          print("Faillll");
          flutterWebviewPlugin.close();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new FailPayfort()));


        }else if(url == "https://www.rasseed.com/success"){
          print("Sccess");
          flutterWebviewPlugin.close();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new SccessPayfort()));

        }else if(url.contains("cancelOperation")){
          print ("cancelOperation_cancelOperation");
          flutterWebviewPlugin.close();
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (BuildContext context) =>
                  new Cart_screen()));
        }
      }
    });
  }

  @override
  void dispose() {
    print("dispose");
    _onUrlChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      key: scaffoldKey,
      url: selectedUrl_1,
      hidden: true,
      appBar: AppBar(title: Text(_title)),
    );
  }
}