import 'package:auto_size_text/auto_size_text.dart';
import 'package:dr_nashar/models/video_model.dart';
import 'package:dr_nashar/screens/quiz_screen.dart';
import 'package:dr_nashar/screens/lecture_screen.dart';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shimmer/shimmer.dart';

import '../user/UserID.dart';
import '../utils/gaps.dart';
import '../widgets/ShowToast.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'assignment_screen.dart';

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({Key? key}) : super(key: key);

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  String errtxt = '';
  String code = '';
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
      body: Container(
        padding: const EdgeInsets.all(12),
        child: YearsData.subjectData.isEmpty
            ? SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      // #TODO
                      'The course is currently empty',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Image.asset(
                      'images/empty_list.png',
                      color: Colors.white.withOpacity(0.5),
                      colorBlendMode: BlendMode.modulate,
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: YearsData.subjectData.length,
                itemBuilder: (context, index) {
                  var lecture = YearsData.subjectData[index];
                  return Container(
                      constraints: BoxConstraints(maxWidth: 600),
                      child: LectureCard(lecture: lecture, index: index));
                  // listItem(index);
                },
              ),
      ),
    );
  }


}

class LectureCard extends StatelessWidget {
  const LectureCard({Key? key, required this.lecture, required this.index})
      : super(key: key);
  final LectureModel lecture;
  final int index;
  @override
  Widget build(BuildContext context) {
    String errtxt = '';
    String code = '';
    var localization = AppLocalizations.of(context)!;

    var width = MediaQuery.of(context).size.width - 24;
    var height = width * .6;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Shimmer.fromColors(
              baseColor: Colors.grey,
              highlightColor: Colors.white70,
              child: Container(
                height: height,
                width: width,
                color: Colors.grey,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Gaps.gap32,
                                    TextField(
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        labelText: localization.code,
                                        hintText: localization.enter_code,
                                      ),
                                      onChanged: (value) {
                                        code = value;
                                      },
                                    ),
                                    Text(
                                      errtxt,
                                      style: const TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  MaterialButton(
                                    onPressed: () async {
                                      bool iscode = false;
                                      int i = 0;
                                      DateTime nowDate = DateTime.now();
                                      final codesData =
                                          await YearsData.get_lecture_codes(
                                              index);
                                      if (codesData) print('');

                                      for (;
                                          i < YearsData.lectureCodes.length;
                                          i++) {
                                        if (YearsData.lectureCodes.keys
                                                .elementAt(i) ==
                                            code) {
                                          iscode = true;
                                          break;
                                        }
                                      }

                                      if (iscode &&
                                          YearsData.lectureCodes.values
                                                  .elementAt(i)['price'] ==
                                              lecture.price.toInt().toString()) {
                                        if (YearsData.lectureCodes.values
                                            .elementAt(i)['used']) {
                                          if (YearsData.lectureCodes.values.elementAt(i)['lectureID']==lecture.id){
                                            if (YearsData.lectureCodes.values
                                                .elementAt(i)['UID'] ==
                                                UserID.userID?.uid) {
                                              DateTime codeDate = YearsData
                                                  .lectureCodes.values
                                                  .elementAt(i)['startDate']
                                                  .toDate();
                                              final dateDifrance =
                                              YearsData.daysBetween(
                                                  codeDate, nowDate);
                                              if (dateDifrance <=
                                                  YearsData.lectureCodes.values
                                                      .elementAt(
                                                      i)['expireDate']) {
                                                YearsData.lectureNumber = index;
                                                YearsData.selectedYear = index;
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        LectureScreen(
                                                            lecture: lecture),
                                                  ),
                                                );
                                              } else {
                                                ShowToast(
                                                    localization.code_expired,
                                                    ToastGravity.TOP);
                                              }
                                            } else {
                                              // #TODO
                                              ShowToast('not allowed user',
                                                  ToastGravity.TOP);
                                            }
                                          }
                                          else{
                                            ShowToast('code not allowed for this lecture',
                                                ToastGravity.TOP);
                                          }
                                        } else {
                                          YearsData.update_code_data(
                                              nowDate,
                                              UserID.userID?.uid,
                                              code,
                                              index,
                                              YearsData.lectureCodes.values
                                                  .elementAt(i),lecture.id);
                                          YearsData.lectureNumber = index;
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LectureScreen(
                                                      lecture: lecture),
                                            ),
                                          );
                                        }
                                      } else {
                                        ShowToast(localization.code_invalid,
                                            ToastGravity.TOP);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      height: 50,
                                      child: const Center(
                                        child: Text(
                                          // #TODO
                                          'Enter',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 25),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Gaps.gap32,
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: width,
                    height: height * .85,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          lecture.image,
                        ),
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.5),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText(
                                  lecture.name,
                                  maxLines: 3,
                                  maxFontSize: 24,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${lecture.videos.length} ${localization.videos}, ${lecture.documents.length} ${localization.documents}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(18.0))),
                                  title: Text(
                                    localization.buy_confirmation,
                                    style: const TextStyle(
                                        color: Colors.blueAccent),
                                  ),
                                  content: Text(
                                    localization.buy_confirmation_alert_message,
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: const Text(
                                        // #TODO
                                        'NO',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    TextButton(
                                      child: const Text(
                                        // #TODO
                                        'YES',
                                        style: TextStyle(
                                            color: Colors.green, fontSize: 20),
                                      ),
                                      onPressed: () async {

                                        YearsData.lectureNumber = index;
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                'LoadingPayScreen');
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            margin: const EdgeInsets.all(8),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: 12,
                              ),
                              child: Text(
                                '${lecture.price} E£',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (lecture.assignment != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AssignmentScreen(
                            lecture: lecture,
                          ),
                        ),
                      );
                    } else {
                      ShowToast('Assignment is not availabe', ToastGravity.TOP);
                    }
                  },
                  child: Container(
                    width: width,
                    height: height * .15,
                    color: Colors.green,
                    child: const Padding(
                      padding: EdgeInsetsDirectional.only(start: 15, top: 6),
                      child: Text(
                        'Take the free Assignment',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
