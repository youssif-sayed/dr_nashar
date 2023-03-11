// Flutter imports:
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/modules/payment/cubit/cubit.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:dr_nashar/utils/gaps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:dotted_border/dotted_border.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../user/UserID.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  var selectedYear = YearsData.defultYear;
  var fetchedyear;
  Widget build(BuildContext context) {
    switch (selectedYear) {
      case 'sec1':
        {
          fetchedyear = YearsData.sec1;
          break;
        }
      case 'sec2':
        {
          fetchedyear = YearsData.sec2;
          break;
        }
      case 'sec3':
        {
          fetchedyear = YearsData.sec3;
          break;
        }
      case 'prep1':
        {
          fetchedyear = YearsData.prep1;
          break;
        }
      case 'prep2':
        {
          fetchedyear = YearsData.prep2;
          break;
        }
      case 'prep3':
        {
          fetchedyear = YearsData.prep3;
          break;
        }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (Rect bounds) => LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff08CE5D),
                      Color(0xff098FEA),
                    ],
                  ).createShader(bounds),
              child: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'ProfileScreen');
                },
                icon: Icon(Icons.account_circle_rounded),
                iconSize: 35,
              )),
        ],
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
      body: Padding(
        padding: EdgeInsets.all(12),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xff08CE5D),
                        Color(0xff098FEA),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        padding: EdgeInsets.only(top: 30, left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome,',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${UserID.userdata['firstName']}',
                              maxLines: 3,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: QrImage(
                          data: "${UserID.userID?.uid}",
                          version: QrVersions.auto,
                          foregroundColor: Colors.white,
                          size: 150.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.gap24,
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'sec1';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '1st sec',
                            style: TextStyle(
                                color: selectedYear == 'sec1'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'sec1' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'sec1'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'sec2';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '2nd sec',
                            style: TextStyle(
                                color: selectedYear == 'sec2'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'sec2' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'sec2'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'sec3';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '3rd sec',
                            style: TextStyle(
                                color: selectedYear == 'sec3'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'sec3' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'sec3'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'prep1';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '1st prep',
                            style: TextStyle(
                                color: selectedYear == 'prep1'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'prep1' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'prep1'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'prep2';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '2nd prep',
                            style: TextStyle(
                                color: selectedYear == 'prep2'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'prep2' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'prep2'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedYear = 'prep3';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '3rd prep',
                            style: TextStyle(
                                color: selectedYear == 'prep3'
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          decoration: BoxDecoration(
                              color:
                                  selectedYear == 'prep3' ? Colors.black : null,
                              borderRadius: BorderRadius.circular(50),
                              border: selectedYear == 'prep3'
                                  ? null
                                  : Border.all(width: 1)),
                        ),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: fetchedyear.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Subject(index);
                    }),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget Subject(int index) {
    return Column(
      children: [
        Gaps.gap24,
        Stack(
          children: [
            Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Color(0xfff1f1f1),
                  borderRadius: BorderRadius.circular(18)),
              child: Column(
                children: [
                  Stack(children: [
                    Shimmer.fromColors(
                      child: Container(
                        height: 150,
                        color: Colors.grey,
                        width: double.maxFinite,
                      ),
                      highlightColor: Colors.white,
                      baseColor: Colors.grey,
                    ),
                    Image.network(
                      '${fetchedyear[index]['image']}',
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ]),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${fetchedyear[index]['name']}',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: (){
                            YearsData.selectedSubject=fetchedyear[index].id;
                            YearsData.selectedYear=selectedYear;
                            Navigator.pushNamed(context, 'LoadingSubjectScreen');

                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(18),
                                border: Border.all(width: 2)),
                            padding: EdgeInsets.all(15),
                            child: Row(
                              children: [
                                Text(
                                  'Start',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(Icons.arrow_forward_ios_rounded),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                ),
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200.withOpacity(0.5)),
                      child: Text(
                        '${fetchedyear[index]['term']}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
