import 'package:dr_nashar/modules/payment/cubit/states.dart';
import 'package:flutter/material.dart';


import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../modules/payment/cubit/cubit.dart';
import '../user/UserID.dart';
import '../utils/gaps.dart';


class LoadingPayScreen extends StatefulWidget {
  const LoadingPayScreen({Key? key}) : super(key: key);

  @override
  State<LoadingPayScreen> createState() => _LoadingPayScreenState();
}
enum payOption {visa,vfCash,fawrey}
class _LoadingPayScreenState extends State<LoadingPayScreen> {

  @override
  payOption _payOption = payOption.visa;

  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Container(
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
        create: (BuildContext context) =>PaymentCubit(),

        child: BlocConsumer<PaymentCubit,PaymentState>(builder: (context,state){

          return SafeArea(child: Container(
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              _payOption = payOption.visa;
                            });
                          },
                          leading: Image(image: AssetImage('images/paymob.png')),
                          title: const Text('Credit Card',style: TextStyle(fontSize: 25),),
                          trailing: Radio(value: payOption.visa, groupValue: _payOption, onChanged: (value) {
                            setState(() {
                              _payOption = value!;
                            });
                          },),
                        ),
                      ),
                    ),
                    Gaps.gap8,
                    /*Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              _payOption = payOption.fawrey;
                            });
                          },
                          leading: Image(image: AssetImage('images/fawrey.png')),
                          title: const Text('Fawrey',style: TextStyle(fontSize: 25),),
                          trailing: Radio(value: payOption.fawrey, groupValue: _payOption, onChanged: (value) {
                            setState(() {
                              _payOption = value!;
                            });
                          },),
                        ),
                      ),
                    ),
                    Gaps.gap8,
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: (){
                            setState(() {
                              _payOption = payOption.vfCash;
                            });
                          },
                          leading: Image(image: AssetImage('images/VF Cash.png')),
                          title: const Text('Vodafone Cash',style: TextStyle(fontSize: 25),),
                          trailing: Radio(value: payOption.vfCash, groupValue: _payOption, onChanged: (value) {
                            setState(() {
                              _payOption = value!;
                            });
                          },),
                        ),
                      ),
                    ),
                    Gaps.gap8,*/
                  ],
                ),
                MaterialButton(
                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    onPressed: (){
                  buildShowDialog(context);
                  PaymentCubit.get(context).getFirstToken(
                      YearsData.subjectData[YearsData.lectureNumber]['price'],
                      UserID.userdata['firstName'], UserID.userdata['lastName'],
                      UserID.userdata['email'], UserID.userdata['phone']);


                },child: Container(
                  constraints:BoxConstraints(maxWidth: 600),
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: Center(child: Text('Pay',style: TextStyle(color:Colors.white,fontSize: 20),)),
                )),
              ],
            ),
          ));
        }, listener: (context,state){
          if (state is PaymentRequestSuccessState) {
            Navigator.of(context).pushReplacementNamed('PayScreen');
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
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
