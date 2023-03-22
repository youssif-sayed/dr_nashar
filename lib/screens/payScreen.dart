import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/const/payMob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../user/yearsData.dart';
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
        onPageStarted: (String url) {
        },

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
    controller.setNavigationDelegate(NavigationDelegate(
      onPageFinished: (String url) {
        if (url.contains('success=true')) {
          String code = createCode();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(18.0))),
                title: const Text(
                  'Your code :',
                  style: TextStyle(color: Colors.blueAccent),
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      code,
                      style: const TextStyle(color: Colors.black,fontSize: 30),
                    ),
                    IconButton(onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: code));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("code copied to clipboard")));
                    }, icon: const Icon(Icons.copy_rounded),color: Colors.grey,iconSize: 20,)
                  ],
                ),
                actions: [
                  TextButton(
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.blueAccent,fontSize: 20),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  ),

                ],
              );
            },
          );
        }
      },
    ));
    return Scaffold(
      body: SafeArea(
        child: WebViewWidget(controller: controller,),
      ),
    );
  }
  String createCode(){
    final random = Random();
    Map<String,dynamic> codeMap = {'used':false,'UID':'','expireDate':7,};
    Map<String,dynamic> newMap={};
    int code = random.nextInt(999999)+100000;
    String finalCode ='DN-${code}';
    newMap.addAll({finalCode:codeMap});
    final docRef = FirebaseFirestore.instance.collection("codes").doc("${YearsData.lectureID}");
    docRef.update(newMap);
    return finalCode;
  }
}
