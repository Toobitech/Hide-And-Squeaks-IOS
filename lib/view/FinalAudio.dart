import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/customTextField.dart';
import 'package:squeak/components/custom_appbar.dart';
import 'package:squeak/controller/record_controller.dart';
import 'package:squeak/models/record_model.dart';
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
import 'package:another_audio_recorder/another_audio_recorder.dart';

class AudioUi extends StatefulWidget {
  const AudioUi({super.key});

  @override
  State<AudioUi> createState() => _AudioUiState();
}

class _AudioUiState extends State<AudioUi> {
  AudioController controller = Get.put(AudioController());

  late List<bool> isPlayingList;
  final RxInt currentAudioIndex = 0.obs;
  bool isCurrent = false;

  recordController controllerRecord = Get.put(recordController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late FlutterSoundRecorder _recordingSession;
  late FlutterSoundPlayer _recordingPlayer;

  AudioPlayer audioPlayer = AudioPlayer();
  AnotherAudioRecorder? _recorder;
  bool isRecording = false;
  bool isPlaying = false;
  int playingIndex =
      -1; // To keep track of which recording is currently playing
  Timer? _timer;
   bool isButtonEnabled = true;
  Duration _currentDuration = Duration();

  @override
  void initState() {
    super.initState();
    controller.getAudioData();

    // controller.audioPlayer;
    // controller.getMylibraryData();
    controllerRecord.GetRecords();

    // _init();
  }

  _init() async {
    Directory appDirectory = await getTemporaryDirectory();
    String uniqueFileName = "${DateTime.now().millisecondsSinceEpoch}.m4a";
    String path = '${appDirectory.path}/$uniqueFileName';
    _recorder = AnotherAudioRecorder(path, audioFormat: AudioFormat.AAC);
    await _recorder?.initialized;
}

  void _startRecording() async {
    if (isRecording) return;

    await _init();  // Ensure recorder is initialized before starting
    await _recorder?.start();
    setState(() {
        isRecording = true;
        isButtonEnabled = false;
      
        _currentDuration = Duration();
    });
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
            _currentDuration += Duration(seconds: 1);
        });
    });
}



void _stopRecording() async {
    if (!isRecording) return;
    if (_timer != null) {
        _timer!.cancel();
        _timer = null;
    }
    Recording? recording = await _recorder?.stop();
    if (recording != null) {
        print("Recording stopped, file saved at: ${recording.path}"); // Debug print
        String formattedDuration = formatDuration(_currentDuration);
        saveRecording(context, audiopath: recording.path , timer:formattedDuration);
        setState(() {
          isButtonEnabled = true;
            // controllerRecord.recordings.add(RecordModel(
            //     file: recording.path,
            //     title: "Recording ${controllerRecord.recordings.length + 1}",
            //     audioLength: formattedDuration
            // ));
            isRecording = false;
            _currentDuration = Duration();
        });
    }
}



  @override
  void dispose() {
    _recordingSession.closeRecorder();
    _recordingPlayer.closePlayer();
    Get.delete<AudioController>();
    Get.delete<recordController>();
    // controller.audioPlayer.dispose();

    super.dispose();
  }

  


  void togglePlayPause(String path, int index) async {
    if (isPlaying && playingIndex == index) {
        await audioPlayer.pause();
        setState(() {
            isPlaying = false;
        });
    } else {
        // Check if the path is a URL or a local file
        Source source;
        if (path.startsWith('http://') || path.startsWith('https://')) {
            source = UrlSource(path);  // Initialize source for URL
        } else {
            // Check if the local file exists before trying to play it
            var file = File(path);
            if (await file.exists()) {
                source = DeviceFileSource(path);  // Initialize source for local file
            } else {
                print("File does not exist: $path");
                return;  // Exit if file does not exist
            }
        }

        // Reinitialize the player to ensure no state or errors persist
        audioPlayer = AudioPlayer();

        try {
            await audioPlayer.play(source);
            setState(() {
                isPlaying = true;
                playingIndex = index;
            });
        } catch (e) {
            print("Error playing audio: $e");
        }
    }
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
                                        SizedBox(
                                          height: Get.height * 0.02,
                                        ),
                                        Text(
                                          '${formatDuration(_currentDuration)}',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            GestureDetector(
                                              onTap: () => isButtonEnabled
                                                  ? _startRecording()
                                                  : null,
                                              child: Container(
                                                height: Get.height * 0.037,
                                                width: Get.width * 0.22,
                                                decoration: BoxDecoration(
                                                    color: isButtonEnabled
                                                        ? AppColors.primaryColor
                                                        : Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Center(
                                                  child: Text(
                                                    "Record",
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
                                            const SizedBox(width: 20),
                                            GestureDetector(
                                              onTap: () => _stopRecording(),
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
                                                                       IconButton(
                    icon: Icon(
                      isPlaying && playingIndex == index ? Icons.pause : Icons.play_arrow,size: 35,color: AppColors.primaryColor,
                    ),
                    onPressed: () => togglePlayPause(recordingPath.file!.toString(), index),
                  ),
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
                                              child: Text(
                                                'List is Empty..',
                                                style: TextStyle(fontSize: 15),
                                              ),
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
                                                                      .whitecolor
                                                                      .withOpacity(
                                                                          0.7),
                                                                  width: 1))),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Obx(() =>
                                                              GestureDetector(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              20),
                                                                  child: Icon(
                                                                    controller.currentlyPlayingIndex.value ==
                                                                                index &&
                                                                            controller
                                                                                .isPlaying.value
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
                                                              SizedBox(width: Get.width*0.12,),
                                                          SizedBox(
                                                            width:
                                                                Get.width * 0.45,
                                                            child: Text(
                                                              item.title,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              softWrap: false,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .whitecolor,
                                                                  fontSize:
                                                                      18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
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
                        // recordTimer = '00:00';
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
                          file: audiopath,
                          title: recordingNames.text,
                          audioLength: timer));

                      setState(() {
                        print(audiopath);
                        controllerRecord.recordings.insert(
                            0,
                            RecordModel(
                              file: audiopath,
                              title: recordingNames.text,
                              audioLength: timer.toString(),
                            ));
                        // recordTimer = '00:00';
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

  String formatDuration(Duration? duration) {
    if (duration == null)
      return "00:00:00"; // Default display for null durations
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
