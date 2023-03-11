

import 'dart:typed_data';
import 'dart:io';
import 'package:dr_nashar/user/yearsData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:video_player/video_player.dart';

import '../utils/gaps.dart';



class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  @override
  late VideoPlayerController videoPlayerController ;
   int selectedVideo = 0;
   bool isVideo=true;
  ChewieController? chewieController;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    _initPlayer();

  }
  void _initPlayer()async{

    final videoUrl =
    await FirebaseStorage.instance.ref().child("${YearsData.subjectData[YearsData.lectureNumber]['videos'][selectedVideo]}");

    videoPlayerController = VideoPlayerController.network(
        '${YearsData.subjectData[YearsData.lectureNumber]['videos'][selectedVideo]}');

    await videoPlayerController.initialize();
    setState(() {
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        autoPlay: false,
        looping: false,

      );
    });

  }
  @override
  void dispose() {
    chewieController?.pause();
    videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return  Scaffold(
      backgroundColor: Colors.black,
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
      body: Stack(
        children: [SingleChildScrollView(
          child: Column(
            children: [
              chewieController!=null?Container(
                height: 200,
                child: Chewie(controller: chewieController!),
              ):
              Shimmer.fromColors(child: Container(
                height: 200,width: double.maxFinite,
                color: Colors.grey,

              ),
                  baseColor: Colors.grey
                  , highlightColor: Colors.white70),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          isVideo=true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        color: isVideo?Colors.transparent:Colors.deepPurpleAccent,
                        child: Center(
                          child: Text('Videos',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: isVideo?Colors.deepPurpleAccent:Colors.white),),
                        ),),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        setState(() {
                          isVideo=false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        color: !isVideo?Colors.transparent:Colors.deepPurpleAccent,
                        child: Center(
                          child: Text('Documents',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: !isVideo?Colors.deepPurpleAccent:Colors.white),),
                        ),),
                    ),
                  ),
                ],
              ),
              Gaps.gap24,
              isVideo?Container(
                child: ListView.builder(
                    itemCount: YearsData.subjectData[YearsData.lectureNumber]['videos'].length,
                    shrinkWrap: true,
                    physics:  NeverScrollableScrollPhysics(),
                    itemBuilder: (context,index){return videoBulider(index);}),
              ):Container(
                  padding: EdgeInsets.all(15),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics:  NeverScrollableScrollPhysics(),
                    itemCount: YearsData.subjectData[YearsData.lectureNumber]['docs'].length,
                    itemBuilder: (context,index){
                      return docBulider(index);
                    },)
              ),
            ],
          ),
        ),
        isLoading?Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Color(0x80000000),
          child: Center(child: CircularProgressIndicator(),),
        ):Container(),
        ]
      ),
    );
  }
  Widget videoBulider(int index){
    return ListTile(
      onTap: (){
        if (selectedVideo!=index){
        setState(() {
          chewieController?.pause();
          videoPlayerController.dispose();
          chewieController?.dispose();
          selectedVideo=index;
          chewieController=null;
          _initPlayer();
        });
        }
      },

      title: Row(

        children: [
          Column(
            children: [
              index==0?Container():Container(width: 2,height: 20,color: Colors.cyan,),
              Container(width: 20,
                height: 20,
                decoration: BoxDecoration(color: index==selectedVideo?Colors.green:Colors.cyan,borderRadius: BorderRadius.circular(50)),
              ),
              index==YearsData.subjectData[YearsData.lectureNumber]['videos'].length-1?Container():Container(width: 2,height: 20,color: Colors.cyan,),
            ],
          ),
          SizedBox(width: 20,),
          Text('${YearsData.subjectData[YearsData.lectureNumber]['videoName'][index]}',style: TextStyle(color: index==selectedVideo?Colors.green:Colors.cyan,fontSize: index==selectedVideo?30:25,fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }

  Widget docBulider (int index){
    return Container(

      child: ListTile(
        onTap:() async {
          setState(() {
            isLoading=true;
          });
          final docUrl =
              YearsData.subjectData[YearsData.lectureNumber]['docs'][index];
          print(docUrl);
          Uint8List? byteList = await FirebaseStorage.instance.refFromURL(docUrl).getData();
          final output = await getTemporaryDirectory();
          var filePath = "${output.path}/${YearsData.subjectData[YearsData.lectureNumber]['videoName'][index]}";
          final file = File(filePath);
          await file.writeAsBytes(byteList!);
          setState(() {
            isLoading=false;
          });
          await OpenDocument.openDocument(filePath: filePath);

      },
        leading: Icon(Icons.description,color: Colors.white,),
        title: Text('${YearsData.subjectData[YearsData.lectureNumber]['docName'][index]}',style: TextStyle(color:Colors.white),),
      ),
    );
  }
}
