import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/payMob.dart';
import '../user/yearsData.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PayRefCodeScreen extends StatelessWidget {
  const PayRefCodeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var localization = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: SizedBox(
          height: 50,
          child: Hero(
              tag: 'logo',
              child: Image.asset(
                'images/Icon/appIcon.png',
              )),
        ),
      ),
      backgroundColor: const Color(0xff0080f9),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'images/paymob.png',
              height: 150,
            ),
            const Text(
              'PayMob',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              '1. Please Pay ',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${YearsData.subjectData[YearsData.lectureNumber].price} EGP',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 35),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                'from anywhere have pay mob services with this number:',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                     Text(
                      '$RefCode',
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () async {
                        await Clipboard.setData(
                             ClipboardData(text: '$RefCode'));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                            Text(localization.code_copied_to_clipboard)));
                      },
                      icon: const Icon(Icons.copy_rounded),
                      color: Colors.grey,
                      iconSize: 20,
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: 300,
              child: Text(
                '2. ask for code on whatsapp with verified transaction picture.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
