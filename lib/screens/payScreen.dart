import 'package:dr_nashar/const/payMob.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
class PayScreen extends StatefulWidget {
  const PayScreen({Key? key}) : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  String url='$IFrameLink$PaymobCardFinalToken';

  @override

  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse('$IFrameLink$PaymobCardFinalToken'));
  Widget build(BuildContext context) {
    print('url: $url');
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller,),
      ),
    );
  }
}
