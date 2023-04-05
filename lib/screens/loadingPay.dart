import 'package:dr_nashar/modules/payment/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../modules/payment/cubit/cubit.dart';
import '../user/UserID.dart';
import '../utils/gaps.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingPayScreen extends StatefulWidget {
  const LoadingPayScreen({Key? key}) : super(key: key);

  @override
  State<LoadingPayScreen> createState() => _LoadingPayScreenState();
}

enum payOption { visa, vfCash, fawrey }

class _LoadingPayScreenState extends State<LoadingPayScreen> {
  payOption _payOption = payOption.visa;

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
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (BuildContext context) => PaymentCubit(),
        child: BlocConsumer<PaymentCubit, PaymentState>(
          builder: (context, state) {
            return SafeArea(
                child: Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _payOption = payOption.visa;
                                });
                              },
                              leading: const Image(
                                  image: AssetImage('images/paymob.png')),
                              title: const Text(
                                'Card',
                                style: TextStyle(fontSize: 25),
                              ),
                              trailing: Radio(
                                value: payOption.visa,
                                groupValue: _payOption,
                                onChanged: (value) {
                                  setState(() {
                                    _payOption = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.gap8,
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _payOption = payOption.fawrey;
                                });
                              },
                              leading: const Image(
                                  image: AssetImage('images/paymob.png')),
                              title: const Text(
                                'Reference Code',
                                style: TextStyle(fontSize: 25),
                              ),
                              trailing: Radio(
                                value: payOption.fawrey,
                                groupValue: _payOption,
                                onChanged: (value) {
                                  setState(() {
                                    _payOption = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.gap8,
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              onTap: () {
                                setState(() {
                                  _payOption = payOption.vfCash;
                                });
                              },
                              leading: const Image(
                                  image: AssetImage('images/VF Cash.png')),
                              title: const Text(
                                'Vodafone Cash',
                                style: TextStyle(fontSize: 25),
                              ),
                              trailing: Radio(
                                value: payOption.vfCash,
                                groupValue: _payOption,
                                onChanged: (value) {
                                  setState(() {
                                    _payOption = value!;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.gap8,
                      ],
                    ),
                  ),
                  MaterialButton(
                      color: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      onPressed: () {
                        buildShowDialog(context);
                        switch (_payOption) {
                          case payOption.visa:
                            {
                              PaymentCubit.get(context).getFirstToken(
                                  YearsData.subjectData[YearsData.lectureNumber]
                                      .price.toInt()
                                      .toString(),
                                  UserID.userdata['firstName'],
                                  UserID.userdata['lastName'],
                                  UserID.userdata['email'],
                                  UserID.userdata['phone'],
                                  true);
                            }
                            break;
                          case payOption.fawrey:
                            {
                              PaymentCubit.get(context).getFirstToken(
                                  YearsData.subjectData[YearsData.lectureNumber]
                                      .price.toInt()
                                      .toString(),
                                  UserID.userdata['firstName'],
                                  UserID.userdata['lastName'],
                                  UserID.userdata['email'],
                                  UserID.userdata['phone'],
                                  false);
                            }
                            break;
                          case payOption.vfCash:
                            {
                              Navigator.of(context)
                                  .pushReplacementNamed('PayVFCashScreen');
                            }
                        }
                      },
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Center(
                            child: Text(
                          localization.pay,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )),
                      )),
                ],
              ),
            ));
          },
          listener: (context, state) {
            if (state is PaymentRequestSuccessState) {
              Navigator.of(context).pushReplacementNamed('PayScreen');
            } else if (state is RefCodeSuccessState) {
              Navigator.of(context).pushReplacementNamed('PayRefCodeScreen');
            }
          },
        ),
      ),
    );
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
