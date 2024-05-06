import 'dart:io' as io;

import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/customTextField.dart';
import 'package:squeak/components/custom_appbar.dart';
import 'package:squeak/controller/record_controller.dart';
import 'package:squeak/models/record_model.dart';
import 'package:squeak/view/audio_play_screen.dart';
import '../App_URL/apiurl.dart';
import '../components/app_assets.dart';
import '../components/colors.dart';
import '../components/custom_playbutton.dart';
import '../components/custom_snakbar.dart';
import '../controller/audio_controller.dart';
import '../models/audio_model.dart';
import 'dart:async';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';

import 'package:audioplayers/audioplayers.dart';


class NewAudioScreen extends StatefulWidget {
    final LocalFileSystem localFileSystem;
  NewAudioScreen({localFileSystem}) : this.localFileSystem = localFileSystem ?? LocalFileSystem();

  @override
  State<NewAudioScreen> createState() => _NewAudioScreenState();
}

class _NewAudioScreenState extends State<NewAudioScreen> {
  AudioController controller = Get.put(AudioController());

  late List<bool> isPlayingList;
  final RxInt currentAudioIndex = 0.obs;
  bool isCurrent = false;

  recordController controllerRecord = Get.put(recordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FlutterSoundRecorder _recordingSession;
  late FlutterSoundPlayer _recordingPlayer;

//
AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
   Duration _duration = Duration.zero;
late Timer _timer;

   

//


  String recordTimer = '00:00';
  late String pathToAudio;
  bool isRecording = false;
  bool isPlaying = false;
  int? currentIndexPlaying;
  bool isButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    controller.getAudioData();

    // controller.audioPlayer;
    // controller.getMylibraryData();
    controllerRecord.GetRecords();

    _initialize();
    _init();
  }

  _initialize() async {
    _recordingSession = FlutterSoundRecorder();
    _recordingPlayer = FlutterSoundPlayer();
    await _recordingSession.openRecorder();
    await Permission.microphone.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    setState(() {
      recordTimer = '00:00';
    });
  }

  @override
  void dispose() {
    _recordingSession.closeRecorder();
    _recordingPlayer.closePlayer();
    Get.delete<AudioController>();
    // controller.audioPlayer.dispose();

    super.dispose();
  }

  startRecording() async {
    if (isRecording) return;
    setState(() {
      isRecording = true;
      setState(() {
        isButtonEnabled = false;
      });
    });
    pathToAudio = (await getApplicationCacheDirectory()).path +
        '/recording_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recordingSession.startRecorder(
      toFile: pathToAudio,
      
      
      codec: Codec.aacADTS
    );
    // startTimer();
  }

  stopRecording() async {
    if (!isRecording) return;
    setState(() {
      isRecording = false;
      isButtonEnabled = true;
    });
    print(pathToAudio);
    await _recordingSession.stopRecorder();
    saveRecording(context, audiopath: pathToAudio, timer: recordTimer);

    // setState(() {
    //   recordings.add(AudioModel(
    //       id: 1,
    //       filePath: pathToAudio,
    //       title: "audio1",
    //       time: recordTimer,
    //       type: "public",
    //       price: "20",
    //       count: 1));
    // });
  }

  playAudio(String path) async {
    print(path);
    if (isPlaying) return;
    setState(() {
      isPlaying = true;
    });
    try {
      await _recordingPlayer.openPlayer();
      await _recordingPlayer.startPlayer(fromURI: path);
      _recordingPlayer.onProgress!.listen((e) {
        final currentPosition = e.position.inSeconds;
        final duration = e.duration.inSeconds;
        setState(() {
          recordTimer = DateFormat('mm:ss', 'en_US')
              .format(DateTime(0, 0, 0, 0, 0, currentPosition));
        });
        if (currentPosition >= duration) {
          _recordingPlayer.stopPlayer();
          setState(() {
            isPlaying = false;
            recordTimer = '00:00';
          });
        }
            });
    } catch (e) {
      print('Error playing recording: $e');
      setState(() {
        isPlaying = false;
      });
    }
  }

  stopPlayback() async {
    if (!isPlaying) return;
    setState(() {
      isPlaying = false;
    });
    await _recordingPlayer.stopPlayer();
  }

 
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
       
        body: SingleChildScrollView(
          child: Container(
              height: Get.height * 1,
              width: Get.width * 1,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(AppAssets.backgroundmain),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(children: [
                const CustomAppBar(),
                SizedBox(height: Get.height * 0.02),
                // Obx(() => CustonPlayButton(
                //       playIcon: Icon(
                //           controller.isPlaying.value
                //               ? Icons.pause
                //               : Icons.play_arrow,
                //           size: 42,
                //           color: AppColors.buttoncolor),
                //       playTap: () async {
                //         print('object123');
                //         print(controller.isPlaying.value);
                //         if (controller.isPlaying.value) {
                //           controller.pauseAudio();
                //         } else {
                //           controller.playAudio(
                //               '${AppUrl.audioPath + controller.audioUrlsList[0]}');
                //         }
                //       },
                //       previousTap: () {},
                //       nextTap: () {
                //         // if (currentAudioIndex.value <
                //         //     controller.audioUrlsList.length - 1) {
                //         //   print('objectNext');
                //         //   // If there is a next audio URL in the list, play it
                //         //   currentAudioIndex.value++;
                //         //   controller.playAudio(
                //         //       '${AppUrl.audioPath + controller.audioUrlsList[currentAudioIndex.value]}');
                //         // } else {
                //         //   print('objectNextNot');
                //         //   // If we're at the end of the list, loop back to the beginning
                //         //   currentAudioIndex.value = 0;
                //         //   controller.playAudio(
                //         //       '${AppUrl.audioPath + controller.audioUrlsList[0]}');
                //         // }
                //       },
                //     )),
                Obx(() => CustonPlayButton(
                      playIcon: Icon(
                          controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 42,
                          color: AppColors.buttoncolor),
                      playTap: () async {
                        print('object123');
                        print(controller.isPlaying.value);
                        if (controller.isPlaying.value) {
                          controller.pauseAudio();
                        } else {
                          controller.playAudio(AppUrl.audioPath +
                              controller.audioSoundList[currentAudioIndex.value]
                                  .filePath
                                  .toString());
                                   showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                                  
                        }
                      },
                      previousTap: () {
                        if (controller.audioSoundList.isNotEmpty) {
                          print(controller.audioSoundList);
                          if (currentAudioIndex.value > 0) {
                            // If there is a previous audio URL in the list, play it
                            print('Previous One');
                            currentAudioIndex.value--;
                            print(currentAudioIndex.value);

                            controller.playAudio(
                              AppUrl.audioPath +
                                  controller
                                      .audioSoundList[currentAudioIndex.value]
                                      .filePath
                                      .toString(),
                            );
                             showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                            print(AppUrl.audioPath +
                                controller
                                    .audioSoundList[currentAudioIndex.value]
                                    .filePath
                                    .toString());
                          } else {
                            print('Previous Two');
                            // If we're at the beginning of the list, loop to the end
                            currentAudioIndex.value =
                                controller.audioSoundList.length - 1;
                            controller.playAudio(
                              AppUrl.audioPath +
                                  controller
                                      .audioSoundList[currentAudioIndex.value]
                                      .filePath
                                      .toString(),
                            );
                             showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                          }
                        } else {
                          showInSnackBar('Audio not available',
                              color: AppColors.errorcolor);
                        }
                      },
                      nextTap: () {
                        if (controller.audioSoundList.isNotEmpty) {
                          if (currentAudioIndex.value <
                              controller.audioSoundList.length - 1) {
                            print('Next One');
                            // If there is a next audio URL in the list, play it
                            currentAudioIndex.value++;
                            print(currentAudioIndex.value);
                            controller.playAudio(
                              AppUrl.audioPath +
                                  controller
                                      .audioSoundList[currentAudioIndex.value]
                                      .filePath
                                      .toString(),
                            );
                             showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                          } else {
                            print('Next Two');
                            // If we're at the end of the list, loop back to the beginning
                            currentAudioIndex.value = 0;
                            controller.playAudio(
                              AppUrl.audioPath +
                                  controller
                                      .audioSoundList[currentAudioIndex.value]
                                      .filePath
                                      .toString(),
                            );
                             showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                          }
                        } else {
                          showInSnackBar('audio not available',
                              color: AppColors.errorcolor);
                        }
                      },
                    )),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCurrent = false;
                                });
                              },
                              child: Container(
                                width: Get.width * 0.45,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    color: isCurrent
                                        ? Colors.black
                                        : const Color.fromARGB(255, 20, 20, 20),
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(20))),
                                child: Center(
                                  child: Text(
                                    'Sound Library',
                                    style: TextStyle(
                                        color: isCurrent
                                            ? AppColors.whitecolor
                                            : AppColors.primaryColor,
                                        fontSize: isCurrent ? 16 : 18,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isCurrent = true;
                                });
                              },
                              child: Container(
                                width: Get.width * 0.45,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                    color: isCurrent
                                        ? const Color.fromARGB(255, 20, 20, 20)
                                        : Colors.black,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(20))),
                                child: Center(
                                  child: Text(
                                    'My Recorder',
                                    style: TextStyle(
                                        color: isCurrent
                                            ? AppColors.primaryColor
                                            : AppColors.whitecolor,
                                        fontSize: isCurrent ? 18 : 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        isCurrent
                            ? Expanded(
                                child: Obx(() => Column(
                                      children: [
                                        SizedBox(height: Get.height*0.02,),
                                        Text(
              '${_duration.inMinutes}:${(_duration.inSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 24),
            ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      switch (_currentStatus) {
                        case RecordingStatus.Initialized:
                          {
                            _start();
                            break;
                          }
                      
                        default:
                          break;
                      }
                    },
                    child: _buildText(_currentStatus),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlue,
                    ),
                  ),
                ),
                ElevatedButton(

                  onPressed: _currentStatus != RecordingStatus.Unset ? _stop : null,
                  child: Text("Stop", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onPlayAudio,
                  child: Text("Play", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                ),
                                            const SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () => stopRecording(),
                                              child: Container(
                                                height: Get.height * 0.037,
                                                width: Get.width * 0.22,
                                                decoration: BoxDecoration(
                                                    color:
                                                        AppColors.primaryColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    "Stop",
                                                    style: TextStyle(
                                                        fontSize: 17,
                                                        color: AppColors
                                                            .whitecolor,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Obx(
                                            () =>
                                                controllerRecord.isLoading.value
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 50),
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: AppColors
                                                              .primaryColor,
                                                        ),
                                                      )
                                                    : controllerRecord
                                                            .recordings.isEmpty
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 70),
                                                            child: Center(
                                                              child: Text(
                                                                'You have No recordings',
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        20),
                                                              ),
                                                            ),
                                                          )
                                                        : Expanded(
                                                            child: ListView
                                                                .builder(
                                                              itemCount:
                                                                  controllerRecord
                                                                      .recordings
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                RecordModel
                                                                    recordingPath =
                                                                    controllerRecord
                                                                            .recordings[
                                                                        index];
                                                                bool
                                                                    isCurrentlyPlaying =
                                                                    index ==
                                                                        currentIndexPlaying;
                                                                print(
                                                                    recordingPath
                                                                        .file);
                                                                return Container(
                                                                  height:
                                                                      Get.height *
                                                                          0.065,
                                                                  decoration:
                                                                      const BoxDecoration(),
                                                                  child:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            15),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border(bottom: BorderSide(color: AppColors.whitecolor.withOpacity(0.7)))),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              // _playAudio(recordingPath);
                                                                              if (currentIndexPlaying == index) {
                                                                                stopPlayback();
                                                                                currentIndexPlaying = null;
                                                                              } else {
                                                                                playAudio(recordingPath.file!.toString());
                                                                                currentIndexPlaying = index;
                                                                              }
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                                                                              size: 30,
                                                                              color: isCurrentlyPlaying ? AppColors.primaryColor : AppColors.pinkcolor,
                                                                            )),
                                                                        SizedBox(
                                                                          width:
                                                                              Get.width * 0.32,
                                                                          child: Text(
                                                                              recordingPath.title!,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              softWrap: false,
                                                                              maxLines: 1,
                                                                              style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.w600, fontSize: 18)),
                                                                        ),
                                                                        Text(
                                                                          "${recordingPath.audioLength}",
                                                                          style: TextStyle(
                                                                              color: AppColors.whitecolor,
                                                                              fontSize: 14),
                                                                        ),
                                                                        GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              showDeleteBox(context, record: controllerRecord.recordings[index], id: recordingPath.id.toString(), title: recordingPath.title);

                                                                              // print("Removing");
                                                                              // _recordings.removeAt(index);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.delete,
                                                                              color: AppColors.whitecolor,
                                                                            )),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ))
                                      ],
                                    )),
                              )
                            : Expanded(
                                child: Obx(
                                  () => controller.isLoading.value
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : controller.audioSoundList.isEmpty
                                          ? const Center(
                                              child: Text('List is Empty..',style: TextStyle(fontSize: 15),),
                                            )
                                          : ListView.builder(
                                              itemCount: controller
                                                  .audioSoundList.length,
                                              itemBuilder: (Context, index) {
                                                AudioModel item = controller
                                                    .audioSoundList[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13, right: 13),
                                                  child: Container(
                                                      height: Get.height * 0.06,
                                                      width: Get.width * 0.8,
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(
                                                                  color: AppColors
                                                                      .whitecolor.withOpacity(0.7),
                                                                  width: 1))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Obx(() =>
                                                              GestureDetector(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 20),
                                                                  child: Icon(
                                                                    controller.currentlyPlayingIndex
                                                                                    .value ==
                                                                                index &&
                                                                            controller
                                                                                .isPlaying
                                                                                .value
                                                                        ? Icons
                                                                            .pause
                                                                        : Icons
                                                                            .play_arrow,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 30,
                                                                  ),
                                                                ),
                                                                onTap:
                                                                    () async {
                                                                  controller.play(
                                                                      index,
                                                                      AppUrl.audioPath +
                                                                          item.filePath);
                                                                },
                                                              )),
                                                          SizedBox(
                                                            width:
                                                                Get.width * 0.3,
                                                            child: Center(
                                                              child: Text(
                                                                item.title,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                softWrap: false,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .whitecolor,
                                                                    fontSize: 18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                            ),
                                                          )
                                                          // ),
                                                          // Text(
                                                          //   item.time,
                                                          //   style: TextStyle(
                                                          //       color: AppColors
                                                          //           .whitecolor,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w800),
                                                          // ),
                                                          // Text(
                                                          //   "${item.count} treats",
                                                          //   style: TextStyle(
                                                          //       color: AppColors
                                                          //           .primaryColor,
                                                          //       fontWeight:
                                                          //           FontWeight
                                                          //               .w800),
                                                          // ),
                                                          // item.type == 'free'
                                                          //     ? GestureDetector(
                                                          //         onTap: () {
                                                          //           controller
                                                          //               .postMyLibrary(
                                                          //                   item.id);
                                                          //         },
                                                          //         child: Icon(
                                                          //           Icons
                                                          //               .cloud_download_outlined,
                                                          //           color: AppColors
                                                          //               .whitecolor,
                                                          //           size: 30,
                                                          //         ),
                                                          //       )
                                                          //     : Container(
                                                          //         padding: const EdgeInsets
                                                          //             .symmetric(
                                                          //             horizontal:
                                                          //                 10,
                                                          //             vertical:
                                                          //                 5),
                                                          //         decoration: BoxDecoration(
                                                          //             borderRadius:
                                                          //                 BorderRadius.circular(
                                                          //                     15),
                                                          //             color: Colors
                                                          //                 .red),
                                                          //         child:
                                                          //             const Text(
                                                          //           'buy',
                                                          //           style: TextStyle(
                                                          //               color: Colors
                                                          //                   .white,
                                                          //               fontWeight:
                                                          //                   FontWeight.normal),
                                                          //         ),
                                                          //       )
                                                        ],
                                                      )),
                                                );
                                              }),
                                ),
                              )
                      ],
                    ),
                  ),
                )
              ])),
        ));
  }
   void showDeleteBox(BuildContext context,
      {required record, required title, required id}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
                color: AppColors.whitecolor, width: 1), // Border color
          ),
          title: Center(
              child: Text(
            "$title ",
            style: TextStyle(color: AppColors.whitecolor, fontSize: 24),
          )),
          content: Text(
            "Do you want to delete this Recording ?",
            style: TextStyle(color: AppColors.whitecolor, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controllerRecord.recordings.remove(record);
                controllerRecord.deleterecordings(id);

                Get.back();
              },
              child: Text(
                "OK",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
  saveRecording(BuildContext context, {required audiopath, required timer}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController recordingNames = TextEditingController();
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
                color: AppColors.whitecolor, width: 1), // Border color
          ),
          title: Form(
            key: _formKey,
            child: CustomTextField(
              hinttext: "Recording Title",
              controller: recordingNames,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Recording Names';
                }

                return null;
              },
              showSuffixIcon: false,
            ),
          ),
          content: Text(
            "Do you want to save this Recording ?",
            style: TextStyle(color: AppColors.primaryColor, fontSize: 15),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        recordTimer = '00:00';
                      });
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 20),
                    )),
                TextButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      Get.back();
                      controllerRecord.postrecoding(RecordModel(
                          file: pathToAudio,
                          title: recordingNames.text,
                          audioLength: recordTimer));

                      setState(() {
                        controllerRecord.recordings.insert(
                            0,
                            RecordModel(
                              file: pathToAudio,
                              title: recordingNames.text,
                              audioLength: recordTimer,
                            ));
                        recordTimer = '00:00';
                      });
                    }
                  },
                  child: Text(
                    "OK",
                    style:
                        TextStyle(color: AppColors.primaryColor, fontSize: 20),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        io.Directory appDocDirectory;
//        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path + customPath + DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder = AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        // after initialization
        var current = await _recorder?.current(channel: 0);
        print(current);
        // should be "Initialized", if all working fine
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          _duration = Duration.zero;
          print(_currentStatus);
        });
      } else {
        return SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      print(e);
    }
  }

  
   _start() async {
    try {
      await _recorder?.start();
      _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        _duration = _duration + Duration(seconds: 1);
      });
    });
      
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = const Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      print(e);
    }
  }

  _resume() async {
    await _recorder?.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder?.pause();
    setState(() {});
  }

  _stop() async {
    _timer.cancel();
    var result = await _recorder?.stop();
    if (result != null) {
      print("Stop recording: ${result.path}");
      print("Stop recording duration: ${result.duration}");

      // Get file from path
      File file = widget.localFileSystem.file(result.path);
      print("File length: ${await file.length()}");

      setState(() {
        _current = result;
        _currentStatus = _current!.status!;
      });
      print(result.path);
      print(recordTimer);
      if (result != null) {
    print("Stop recording: ${result.path}");
    print("Stop recording duration: ${result.duration}");

    // Call saveRecording function to add recording to the list
    saveRecording(context, audiopath: result.path, timer: result.duration);
  }
      

      // Show delete confirmation dialog
     
    
    }
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    Source source = DeviceFileSource(_current!.path!);
    await audioPlayer.play(source);
  }
}

