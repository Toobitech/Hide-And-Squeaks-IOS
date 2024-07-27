import 'dart:async';

import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/controller/video_controller.dart';
import 'package:squeak/models/comment_model.dart';
import 'package:squeak/models/video_model.dart';
import 'package:video_player/video_player.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../components/colors.dart';
import '../components/custom_snakbar.dart';

class VideoPlayerScreen extends StatefulWidget {
  final VideoModel view;
  final List<Comment> comments;

  const VideoPlayerScreen({super.key, required this.view, required this.comments});

  @override
  _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  TextEditingController commentController = TextEditingController();
   TextEditingController reportController = TextEditingController();
  VideoController controller = Get.put(VideoController());

  String formatDate(String dateStr) {
    DateTime dateTime = DateTime.parse(dateStr);
    return DateFormat('dd MMMM yyyy').format(dateTime);
  }

  String formattimeago(DateTime dateTime) {
    final DateFormat formatter = DateFormat('E, d MMM, y');
    return formatter.format(dateTime);
  }

  late ChewieController _chewieController;
  late VideoPlayerController videoPlayerController;
  var isLoading=true;

  @override
  void initState (){
    super.initState();
    controller.ViewData(widget.view.id!);
    videoPlayerController = VideoPlayerController.network(
      
  widget.view.file_path.toString());
  Timer(Duration(seconds: 5), ()  {
    
    setState(() {
      isLoading=false;
    });
  });
// )..initialize().catchError((error) {
//   // Handle video initialization error
//   print("Video initialization error: $error");
// });

//     // videoPlayerController = VideoPlayerController.networkUrl(
//  Uri(path:  widget.view.file_path.toString()),
//     // );

    _chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 100/100,
      allowPlaybackSpeedChanging: true,
      allowedScreenSleep: false,
      autoInitialize: true,
      showControls: true,
      showOptions: true,
      cupertinoProgressColors:
          ChewieProgressColors(bufferedColor: AppColors.primaryColor),
      placeholder: Container(
        color: Color(0xff3f3f3f),
      ),
      materialProgressColors: ChewieProgressColors(
        playedColor: AppColors.primaryColor,
        handleColor: AppColors.whitecolor,
        backgroundColor: Colors.grey,
        bufferedColor: Colors.black54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String newdate = formatDate(widget.view.created_at.toString());
    //  DateTime providedDate = DateTime.parse(widget.view.created_at.toString());

    // // Current date and time
    // DateTime currentDate = DateTime.now();

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: Get.height * 1,
            width: Get.width * 1,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(AppAssets.backgroundmain),
                    fit: BoxFit.fill)),
            child: SingleChildScrollView(
              child: Column(
                children: [
        // isLoading? Container(
        //    height: Get.height * 0.5,
        //             width: Get.width * 1,
        //   child: Center(child: CircularProgressIndicator(color: AppColors.primaryColor,),))  :
          Container(
                    height: Get.height * 0.5,
                    width: Get.width * 1,
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: [
                        SizedBox(
                          height: Get.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Share.share(widget.view.file_path.toString());
                              },
                              child: Container(
                                height: Get.height * 0.037,
                                width: Get.width * 0.22,
                                decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                  child: Text(
                                    "Share",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: AppColors.whitecolor,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: commentController,
                              textAlign: TextAlign.start,
                              cursorColor: AppColors.whitecolor,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              decoration: InputDecoration(
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    if (commentController.text.isNotEmpty) {
                                      print(widget.view.id!);
                                      controller.postComment(
                                          commentController.text,
                                          widget.view.id!);
                                      // controller.ViewData(widget.view.id!);
                                      widget.view.totalComments =
                                          (widget.view.totalComments ?? 0) + 1;
          
                                      Comment newComment = Comment(
                                          comment: commentController.text,
                                          userId: widget.view.id,
                                          createdAt: DateTime.now().toString(),
                                          user: User(
                                              id: widget.view.id!,
                                              name: appStorage
                                                  .read("name")
                                                  .toString(),
                                              profile: appStorage
                                                  .read("profile")
                                                  .toString()));
          
                                      setState(() {
                                        widget.comments.insert(0, newComment);
                                      });
                                      commentController.clear();
                                    } else {
                                      showInSnackBar("Enter Comment",
                                          color: AppColors.errorcolor);
                                    }
                                  },
                                  child: Icon(
                                    Icons.add_comment,
                                    color: AppColors.whitecolor,
                                    size: 25,
                                  ),
                                ),
                                hintText: "Comment ...",
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: const BorderSide(
                                      color: Colors.white, width: 2.0),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.whitecolor.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                ),
                                constraints: BoxConstraints.tightFor(
                                  height: Get.height * 0.04,
                                  width: Get.width * 0.56,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.postLike(widget.view.id!);
          
                                addLikes() {
                                  if (widget.view.userLikedVideo == true) {
                                    setState(() {
                                      widget.view.userLikedVideo = false;
                                    });
          
                                    return widget.view.totalLikes =
                                        (widget.view.totalLikes ?? 0) - 1;
                                  } else {
                                    setState(() {
                                      widget.view.userLikedVideo = true;
                                    });
          
                                    return widget.view.totalLikes =
                                        (widget.view.totalLikes ?? 0) + 1;
                                  }
                                }
          
                                addLikes();
                                if (widget.view.totalLikes! < 0) {
                                  widget.view.totalLikes = 0;
                                }
                              },
                              child: Icon(
                                Icons.favorite_outlined,
                                color: widget.view.userLikedVideo!
                                    ? AppColors.favouritecolor
                                    : AppColors.whitecolor,
                                size: 30,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: Get.height * 0.005,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppColors.whitecolor, width: 1))),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 2,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: Get.width * 0.57,
                                    height: Get.height * 0.05,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: Get.height * 0.05,
                                          width: Get.width * 0.1,
                                          decoration: BoxDecoration(
                                              color: AppColors.textfieldcolor,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: widget.view
                                                              .user_profile !=
                                                          null
                                                      ? Image.network(widget
                                                              .view.user_profile
                                                              .toString())
                                                          .image
                                                      : AssetImage(
                                                          AppAssets.back2),
                                                  fit: BoxFit.fill)),
                                        ),
                                        // CircleAvatar(
                                        //   backgroundColor: Colors.transparent,
                                        //   radius: 25,
                                        //   backgroundImage: widget.view.user_profile != null? Image.network(widget.view.user_profile.toString()).image:AssetImage(AppAssets.back2) ,
                                        //   // child: Icon(
                                        //   //   Icons.person,
                                        //   //   color: AppColors.whitecolor,
                                        //   //   size: 30,
                                        //   // ),
                                        // ),
                                        SizedBox(
                                          width: Get.height * 0.015,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.view.user_name!,
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: AppColors.whitecolor,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              "Published $newdate",
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: AppColors.whitecolor.withOpacity(0.8),
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: Get.height * 0.058,
                                    width: Get.width * 0.35,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                widget.view.totalComments
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.whitecolor),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.01,
                                              ),
                                              Icon(
                                                Icons.mode_comment_rounded,
                                                color: AppColors.whitecolor,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                widget.view.totalLikes.toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.whitecolor),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.01,
                                              ),
                                              Icon(
                                                Icons.favorite,
                                                color: AppColors.favouritecolor,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                widget.view.totalViews.toString(),
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: AppColors.whitecolor),
                                              ),
                                              SizedBox(
                                                width: Get.width * 0.01,
                                              ),
                                              Icon(
                                                Icons.person,
                                                color: AppColors.primaryColor,
                                                size: 20,
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                "Comments",
                                style: TextStyle(
                                    fontSize: 15, color: AppColors.whitecolor),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                ReportWindow(context);
                              },
                              child: Container(
                                  height: Get.height * 0.037,
                                  width: Get.width * 0.28,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Icon(Icons.flag_rounded,color: Colors.white,),
                                       SizedBox(width: Get.width*0.02,),
                                      Center(
                                        child: Text(
                                          "Report",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: AppColors.whitecolor,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ),
                          ],
                        ),
                        SizedBox(height: Get.height * 0.01),
                        Container(
                          height: Get.height * 0.285,
                          width: Get.width * 0.95,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: ListView.builder(
                              itemCount: widget.comments.length,
                              itemBuilder: (context, int index) {
                                Comment usercomment = widget.comments[index];
                                String formateddays = formatRelativeTime(
                                    usercomment.createdAt!, DateTime.now());
                                print(formateddays);
                                    
                                return Container(
                                  height: Get.height * 0.065,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: AppColors.whitecolor.withOpacity(0.7),
                                              width: 1))),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                AppUrl.imageUrl +
                                                    usercomment.user!.profile
                                                        .toString()),
                                            radius: 20,
                                          ),
                                          SizedBox(
                                            width: Get.width * 0.04,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    usercomment.user!.name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .whitecolor),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.03,
                                                  ),
                                                  Text(
                                                    "$formateddays",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AppColors
                                                            .whitecolor),
                                                  ),
                                                  SizedBox(
                                                    width: Get.width * 0.02,
                                                  ),
                                                  Icon(
                                                    Icons.favorite,
                                                    color: AppColors
                                                        .favouritecolor,
                                                    size: 15,
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: Get.width*0.7,
                                                child: Text(
                                                  
                                                  usercomment.comment.toString(),
                                                  overflow: TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w100,
                                                      color:
                                                          AppColors.whitecolor.withOpacity(0.8)),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void ReportWindow(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: AppColors.whitecolor,
            width: 1,
          ),
        ),
        child: Container(
          height: Get.height * 0.5,
          width: Get.width*0.8, // Set your desired height here
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Kindly Enter The Reporting reason",textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AppColors.whitecolor),
              ),
                SizedBox(height:Get.height*0.02),
            Expanded(
                child: TextFormField(
                  maxLines: null,
                  controller: reportController,
                  expands: true,
                  style: TextStyle(color: AppColors.whitecolor),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    hintText: "Enter your reason here...",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height:Get.height*0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "cancel",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                       if(reportController.text.isNotEmpty){
                     
                     Map<String, dynamic> data = {
                            "video_id": widget.view.id,
                            "issue": reportController.text,
                          };
                          print(data); 
                          // Print the data map
                          


                        await controller.reportVideo(data);
                        Get.back();

                       }
                       else{
                        showInSnackBar("Kindly Enter the Reason of Reporting",color: AppColors.errorcolor);
                       }
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: AppColors.primaryColor,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}


  @override
  void dispose() {
    videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

String formatRelativeTime(String startStr, DateTime end) {
  DateTime start = DateTime.parse(startStr);
  Duration difference = end.difference(start);
  String relativeTime;

  if (end.isAfter(start)) {
    if (difference.inDays > 365) {
      relativeTime = '${_differenceInYears(start, end)} years ago';
    } else if (difference.inDays > 30) {
      relativeTime = '${_differenceInMonths(start, end)} months ago';
    } else if (difference.inDays > 7) {
      relativeTime = '${_differenceInWeeks(start, end)} weeks ago';
    } else if (difference.inDays > 0) {
      relativeTime = '${_differenceInDays(start, end)} days ago';
    } else if (difference.inHours > 0) {
      relativeTime = '${_differenceInHours(start, end)} hours ago';
    } else if (difference.inMinutes > 0) {
      relativeTime = '${_differenceInMinutes(start, end)} minutes ago';
    } else {
      relativeTime = 'Just now';
    }
  } else {
    relativeTime = 'Invalid date';
  }

  return relativeTime;
}

int _differenceInYears(DateTime start, DateTime end) {
  return end.year - start.year;
}

int _differenceInMonths(DateTime start, DateTime end) {
  return (end.year - start.year) * 12 + end.month - start.month;
}

int _differenceInWeeks(DateTime start, DateTime end) {
  return end.difference(start).inDays ~/ 7;
}

int _differenceInDays(DateTime start, DateTime end) {
  return end.difference(start).inDays;
}

int _differenceInHours(DateTime start, DateTime end) {
  return end.difference(start).inHours;
}

int _differenceInMinutes(DateTime start, DateTime end) {
  return end.difference(start).inMinutes;
}