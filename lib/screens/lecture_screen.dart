import 'dart:io';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:dr_nashar/models/video_model.dart';
import 'package:dr_nashar/screens/quiz_screen.dart';
import 'package:dr_nashar/widgets/ShowToast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LectureScreen extends StatefulWidget {
  const LectureScreen({Key? key, required this.lecture}) : super(key: key);
  final LectureModel lecture;
  @override
  State<LectureScreen> createState() => _LectureScreenState();
}

class _LectureScreenState extends State<LectureScreen> {
  late VideoPlayerController videoPlayerController;

  int selectedVideoIndex = 0;
  bool isVideo = true;
  ChewieController? chewieController;
  late LectureModel lecture;
  @override
  void initState() {
    lecture = widget.lecture;
    _initPlayer();
    super.initState();
  }

  late var selectedVideo = lecture.videos[selectedVideoIndex];

  late var isVideoInitialized = videoPlayerController.value.isInitialized;

  void _initPlayer() {
    videoPlayerController =
        VideoPlayerController.network('${selectedVideo.url}.mp4')
          ..initialize().then(
            (value) => setState(
              () {
                isVideoInitialized = true;
              },
            ),
          );
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
    );
  }

  final viableFileExtensions = [
    'pdf',
    'xlsx',
    'docs',
    'ppt',
    'zip',
    'png',
    'jpg',
    'xls',
    'doc',
    'jpeg'
  ];

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController?.dispose();
    chewieController?.pause();
    super.dispose();
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    print(videoPlayerController.value);
    var localization = AppLocalizations.of(context)!;
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: false,
      looping: false,
    );
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                chewieController != null
                    ? SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: videoPlayerController.value.aspectRatio,
                          child: !isVideoInitialized
                              ? const Center(child: CircularProgressIndicator())
                              : Chewie(controller: chewieController!),
                        ),
                      )
                    : Shimmer.fromColors(
                        baseColor: Colors.grey,
                        highlightColor: Colors.white70,
                        child: Container(
                          height: 200,
                          width: double.maxFinite,
                          color: Colors.grey,
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.lecture.name,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24.0),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.lecture.videos.length,
                          itemBuilder: (context, index) {
                            var video = widget.lecture.videos[index];
                            return IntrinsicHeight(
                              child: Stack(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      if (isVideoInitialized &&
                                          selectedVideoIndex != index) {
                                        setState(
                                          () {
                                            isVideoInitialized = false;
                                            selectedVideoIndex = index;
                                          },
                                        );
                                        chewieController?.pause();
                                        videoPlayerController =
                                            VideoPlayerController.network(
                                                '${video.url}.mp4')
                                              ..initialize().then(
                                                (value) => setState(
                                                  () {
                                                    isVideoInitialized = true;
                                                  },
                                                ),
                                              );
                                      }
                                    },
                                    leading: Icon(
                                      Icons.play_circle_outline_rounded,
                                      size: 34,
                                      color: index == selectedVideoIndex
                                          ? Colors.blue[600]
                                          : null,
                                    ),
                                    title: Text(
                                      video.name,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        color: index == selectedVideoIndex
                                            ? Colors.blue[600]
                                            : null,
                                      ),
                                    ),
                                  ),
                                  index == selectedVideoIndex
                                      ? Container(
                                          width: 5,
                                          color: Colors.blue[600],
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.documents,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: widget.lecture.documents.length,
                                itemBuilder: (context, index) {
                                  var document =
                                      widget.lecture.documents[index];
                                  return ListTile(
                                    onTap: () async {
                                      final doc = lecture.documents[index];
                                      var extension = doc.name
                                          .split('.')
                                          .last
                                          .toLowerCase();
                                      if (extension == 'xlsx') {
                                        extension = 'xls';
                                      }
                                      if (extension == 'docs') {
                                        extension = 'doc';
                                      }

                                      if (viableFileExtensions
                                          .contains(extension)) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        Uint8List? byteList =
                                            await FirebaseStorage.instance
                                                .refFromURL(doc.src)
                                                .getData();
                                        final output =
                                            await getTemporaryDirectory();
                                        var filePath =
                                            "${output.path}/${lecture.videos[index].name}";
                                        final file = File(filePath);
                                        await file.writeAsBytes(byteList!);
                                        await OpenFile.open(filePath);
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    },
                                    leading: Icon(
                                      Icons.description_outlined,
                                      size: 34,
                                      color: Colors.blue[600],
                                    ),
                                    title: Text(
                                      document.name,
                                      style: TextStyle(
                                        color: Colors.blue[600],
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                localization.quizzes,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              ListTile(
                                onTap: () {
                                  if (lecture.quiz == null) {
                                    ShowToast('Quiz is not available now',
                                        ToastGravity.TOP);
                                  } else {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            QuizScreen(lecture: lecture),
                                      ),
                                    );
                                  }
                                },
                                leading: Icon(
                                  Icons.quiz,
                                  size: 34,
                                  color: Colors.blue[600],
                                ),
                                title: Text(
                                  'Take the quiz',
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black54,
                  child: const Center(child: CircularProgressIndicator()),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
