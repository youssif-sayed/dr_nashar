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


class LoadingPayScreen extends StatefulWidget {
  const LoadingPayScreen({Key? key}) : super(key: key);

  @override
  State<LoadingPayScreen> createState() => _LoadingPayScreenState();
}

class _LoadingPayScreenState extends State<LoadingPayScreen> {
  int counter =1;
  @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {

    super.dispose();

  }
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
          if (counter==1) {
            counter++;
            PaymentCubit.get(context).getFirstToken(
                YearsData.subjectData[YearsData.lectureNumber]['price'],
                UserID.userdata['firstName'], UserID.userdata['lastName'],
                UserID.userdata['email'], UserID.userdata['phone']);
          }
          return SafeArea(
            child: Center(
              child: SpinKitFadingCircle(color: Colors.blueAccent,size: 100.0,),
            ),
          );
        }, listener: (context,state){
          if (state is PaymentSuccessState) {
            Navigator.of(context).pushReplacementNamed('PayScreen');
          }
        },
        ),
      ),
    );
  }
}
