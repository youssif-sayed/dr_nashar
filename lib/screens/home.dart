// Flutter imports:
import 'dart:ui';

import 'package:dr_nashar/user/yearsData.dart';
import 'package:dr_nashar/utils/gaps.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../user/UserID.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  var selectedYear = YearsData.defultYear;
  var fetchedyear;

  Map grades = {
    '1st sec': 'sec1',
    '2nd sec': 'sec2',
    '3rd sec': 'sec3',
    '1st prep': 'prep1',
    '2nd prep': 'prep2',
    '3rd prep': 'prep3',
  };

  @override
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff098FEA),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 150,
                      padding: const EdgeInsets.only(top: 30, left: 10,right: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              AppLocalizations.of(context)!.welcome,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${UserID.userdata['firstName']}',
                              maxLines: 3,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold),
                            ),
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
              SizedBox(
                height: 40,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: grades.length,
                    itemBuilder: (context, index) {
                      var grade = grades.keys.toList()[index];
                      var gradeValue = grades[grade];
                      return Padding(
                        padding: const EdgeInsets.only(right: 5.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedYear = gradeValue;
                              print(selectedYear);
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: selectedYear == gradeValue
                                    ? Colors.black
                                    : null,
                                borderRadius: BorderRadius.circular(50),
                                border: selectedYear == gradeValue
                                    ? null
                                    : Border.all(width: 1)),
                            child: FittedBox(
                              fit: BoxFit.fitHeight,
                              child: Text(
                                grade,
                                style: TextStyle(
                                  color: selectedYear == gradeValue
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Gaps.gap24,
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: .9992,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fetchedyear.length,
                itemBuilder: (BuildContext context, int index) {
                  return SubjectCard(
                    fetchedYear: fetchedyear,
                    index: index,
                    selectedYear: selectedYear,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  const SubjectCard(
      {Key? key,
      required this.fetchedYear,
      required this.index,
      required this.selectedYear})
      : super(key: key);
  final List fetchedYear;
  final int index;
  final String selectedYear;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        LayoutBuilder(builder: (context, constraints) {
          var width = constraints.maxWidth - 32;
          return Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: const Color(0xfff1f1f1),
                borderRadius: BorderRadius.circular(18)),
            child: Column(
              children: [
                SizedBox(
                  height: constraints.maxHeight * .65,
                  child: Stack(
                    children: [
                      Shimmer.fromColors(
                        highlightColor: Colors.white,
                        baseColor: Colors.grey,
                        child: Container(
                          color: Colors.grey,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                      Image.network(
                        '${fetchedYear[index]['image']}',
                        fit: BoxFit.cover,
                        height: constraints.maxHeight * .65,
                        width: MediaQuery.of(context).size.width,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * .35,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, right: 12, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * .5,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${fetchedYear[index]['name']}',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: width * .4,
                          child: InkWell(
                            onTap: () {
                              YearsData.selectedSubject = fetchedYear[index].id;
                              YearsData.selectedYear = selectedYear;
                              print(fetchedYear[index].id);
                              Navigator.pushNamed(
                                  context, 'LoadingSubjectScreen');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(width: 2)),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.start,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
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
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200.withOpacity(0.5)),
                  child: Text(
                    '${fetchedYear[index]['term']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
