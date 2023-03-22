import 'dart:async';

import 'package:dr_nashar/user/yearsData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSubjectScreen extends StatefulWidget {
  const LoadingSubjectScreen({Key? key}) : super(key: key);

  @override
  State<LoadingSubjectScreen> createState() => _LoadingSubjectScreenState();
}

class _LoadingSubjectScreenState extends State<LoadingSubjectScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    bool issubject = await YearsData.get_subject_data();
    if (issubject) Navigator.of(context).pushReplacementNamed('SubjectScreen');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
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
      body: const SafeArea(
        child: Center(
          child: SpinKitFadingCircle(
            color: Colors.blueAccent,
            size: 100.0,
          ),
        ),
      ),
    );
  }
}
