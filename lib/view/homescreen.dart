import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/components/custom_appbar.dart';
import 'package:gradient_slider/gradient_slider.dart';
import 'package:squeak/controller/profile_controller.dart';
import '../App_URL/apiurl.dart';
import '../components/colors.dart';
import '../components/custom_playbutton.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import '../components/custom_snakbar.dart';
import '../controller/audio_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AudioController controller = Get.put(AudioController());
  ProfileController newcontroller = Get.put(ProfileController());

  late List<bool> isPlayingList;
  final RxInt currentAudioIndex = 0.obs;
  double _sliderValue = 1;
  @override
  void initState() {
    super.initState();
    newcontroller.getUserProfile();
    controller.getAudioData();
    // controller.audioPlayer;

    // controller.getMylibraryData();
  }

  @override
  void dispose() {
    Get.delete<AudioController>();

    // controller.onClose();
    // controller.audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: Get.height * 1,
        width: Get.width * 1,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppAssets.backgroundmain), fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: Get.height * 0.02),
              CustomAppBar(show:true),
              SizedBox(height: Get.height * 0.008),
              CircleAvatar(
                radius: 175,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage(AppAssets.dog),

              ),
              // Container(
              //     height: Get.height * 0.33,
              //     width: Get.width * 0.6,
              //     decoration: BoxDecoration(
              //         image: DecorationImage(
              //             image: AssetImage(AppAssets.dog), fit: BoxFit.fill))
              //     // child: Center(
              //     //   child: Padding(
              //     //     padding: EdgeInsets.only(top: 15.25, left: 1.7),
              //     //     child: Obx(
              //     //       () => CircleAvatar(
              //     //         radius: 116,
              //     //         backgroundImage:
              //     //             newcontroller.userDataList.value.profile != null
              //     //                 ? Image.network(AppUrl.imageUrl +
              //     //                         newcontroller
              //     //                             .userDataList.value.profile!)
              //     //                     .image
              //     //                 : null,
              //     //         backgroundColor: Colors.transparent,
              //     //       ),
              //     //     ),
              //     //   ),
              //     // )
              //     ),
              SizedBox(height: Get.height * 0.022),
              Text(
                "Volume",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 26,
                    color: AppColors.whitecolor),
              ),
              SizedBox(height: Get.height * 0.009),

              Container(
                width: Get.width * 0.65,
                height: Get.height * 0.021,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppAssets.slider),
                    fit: BoxFit.fill,
                  ),
                ),
                child: GradientSlider(
                  thumbAsset: "assets/images/button.png",
                  thumbHeight: 36,
                  thumbWidth: 25,
                  inactiveTrackColor: Colors.transparent,
                  trackHeight: Get.height * 0.007,
                  activeTrackGradient: const LinearGradient(
                    colors: [Color(0xff420303), Color(0xffde4343)],
                  ),
                  slider: Slider(
                    min: 0.0,
                    max: 1.0,
                    onChanged: (double Volume) {
                      setState(() {
                        _sliderValue = Volume.clamp(0.0, 1.0);
                        PerfectVolumeControl.setVolume(_sliderValue);
                      });
                    },
                    value: _sliderValue,
                  ),
                ),
              ),

              SizedBox(
                height: Get.height * 0.022,
              ),
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
                        controller.playAudio(
                            AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString());
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
                            AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString(),
                          );
                           showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                          print(
                              AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString());
                        } else {
                          print('Previous Two');
                          // If we're at the beginning of the list, loop to the end
                          currentAudioIndex.value =
                              controller.audioSoundList.length - 1;
                          controller.playAudio(
                            AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString(),
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
                            AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString(),
                          );
                           showInSnackBar(
            "Audio Player playing ${controller.audioSoundList[currentAudioIndex.value].title}...",
            color: AppColors.errorcolor);
                        } else {
                          print('Next Two');
                          // If we're at the end of the list, loop back to the beginning
                          currentAudioIndex.value = 0;
                          controller.playAudio(
                            AppUrl.audioPath + controller.audioSoundList[currentAudioIndex.value].filePath.toString(),
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
              //       previousTap: () {
              //         if (controller.audioUrlsList.isNotEmpty) {
              //           if (currentAudioIndex.value > 0) {
              //             // If there is a previous audio URL in the list, play it
              //             print('Previous One');
              //             currentAudioIndex.value--;
              //             controller.playAudio(
              //               '${AppUrl.audioPath + controller.audioUrlsList[currentAudioIndex.value]}',
              //             );
              //           } else {
              //             print('Previous Two');
              //             // If we're at the beginning of the list, loop to the end
              //             currentAudioIndex.value =
              //                 controller.audioUrlsList.length - 1;
              //             controller.playAudio(
              //               '${AppUrl.audioPath + controller.audioUrlsList[currentAudioIndex.value]}',
              //             );
              //           }
              //         } else {
              //           showInSnackBar('Audio not Available',
              //               color: Colors.red);
              //         }
              //       },
              //       nextTap: () {
              //         if (controller.audioUrlsList.isNotEmpty) {
              //           if (currentAudioIndex.value <
              //               controller.audioUrlsList.length - 1) {
              //             print('Next One');
              //             // If there is a next audio URL in the list, play it
              //             currentAudioIndex.value++;
              //             controller.playAudio(
              //               '${AppUrl.audioPath + controller.audioUrlsList[currentAudioIndex.value]}',
              //             );
              //           } else {
              //             print('Next Two');
              //             // If we're at the end of the list, loop back to the beginning
              //             currentAudioIndex.value = 0;
              //             controller.playAudio(
              //               '${AppUrl.audioPath + controller.audioUrlsList[0]}',
              //             );
              //           }
              //         } else {
              //           showInSnackBar('Audio not Available',
              //               color: Colors.red);
              //         }
              //       },
              //     )),
              // CustonPlayButton(
              //   playIcon: Icon(Icons.play_arrow_rounded,
              //       size: 42, color: AppColors.buttoncolor),
              //   playTap: () {
              //     // Get.to(VideoThumbnailScreen());
              //   },
              //   previousTap: () {},
              //   nextTap: () {},
              // ),
              SizedBox(height: Get.height * 0.02),

              // GestureDetector(
              //     onTap: () async {
              //       await controller.GoogleSignOut();
              //       await controller.facebookSignOut();

              //       appStorage.erase();

              //       Get.off(LoginScreen());
              //     },
              //     child: CustomButton(fieldname: "Sign Out"))
            ],
          ),
        ),
      ),
    );
  }
}
