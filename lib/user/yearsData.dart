


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dr_nashar/user/UserID.dart';

class YearsData{

  static var  defultYear;
  static var sec1,sec2,sec3,prep1,prep2,prep3;
  static var selectedSubject,selectedYear,subjectData;
  static var lectureNumber,lectureCodes;

  static void set_defult_year (){
    switch (UserID.userdata['grade']){
      case 'first perportry':{
        defultYear = 'prep1';
        break;
      }
      case 'second perportry':{
        defultYear = 'prep2';
        break;
      }
      case 'third perportry':{
        defultYear = 'prep3';
        break;
      }
      case 'first secondary':{
        defultYear = 'sec1';
        break;
      }
      case 'second secondary':{
        defultYear = 'sec2';
        break;
      }
      case 'third secondary':{
        defultYear = 'sec3';
        break;
      }
    }
}
  static Future<bool> get_years_data() async {
     await FirebaseFirestore.instance.collection("sec1-lectures").get().then((value) {

      sec1 = value.docs;
    });
     await FirebaseFirestore.instance.collection("sec2-lectures").get().then((value) {

      sec2 = value.docs;

    });
     await FirebaseFirestore.instance.collection("sec3-lectures").get().then((value) {

      sec3=value.docs;
    });
     await FirebaseFirestore.instance.collection("prep1-lectures").get().then((value) {
      prep1=value.docs;
    });
     await FirebaseFirestore.instance.collection("prep2-lectures").get().then((value) {
      prep2=value.docs;
    });
     await FirebaseFirestore.instance.collection("prep3-lectures").get().then((value) {
      prep3=value.docs;
    });


        return true;
  }
  static Future<bool> get_subject_data() async {
    await FirebaseFirestore.instance.collection("${selectedYear}-lectures").doc('${selectedSubject}').collection('videos').get().then((value) {
      subjectData=value.docs;
    });
    return true;
  }
  static Future<bool> get_lecture_codes(index) async {

    await FirebaseFirestore.instance.collection("codes").doc('${subjectData[index]['id']}').get().then((value) {
      lectureCodes=value.data() as Map<String,dynamic>;
    });
    return true;
  }
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
  static void update_code_data(date,uid,code,index,map)async{
    var updatedmap = map;
    Timestamp timeStamp = Timestamp.fromDate(date);
    updatedmap['used']=true;
    updatedmap['UID']=uid;
    updatedmap['startDate']=timeStamp;
    await FirebaseFirestore.instance.collection('codes').doc('${subjectData[index]['id']}').update({'$code': updatedmap});

  }


}