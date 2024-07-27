import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/components/custom_appbar.dart';
import 'package:squeak/components/custom_menu_btn.dart';
import 'package:squeak/controller/auth_controller.dart';
import 'package:squeak/view/FinalAudio.dart';
import 'package:squeak/view/NewPrivacy.dart';
import 'package:squeak/view/login_screen.dart';
import 'package:squeak/view/profile_screen.dart';
import 'package:squeak/view/setting_screen.dart';
import 'package:squeak/view/socialfeed.dart';
import 'package:squeak/view/policy_screen.dart';
import 'package:squeak/view/video_upload_screen.dart';
import '../components/colors.dart';
import 'audio_play_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      body: Container(
        height: Get.height * 1,
        width: Get.width * 1,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AppAssets.menuback),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            AppColors.filtercolor, // Adjust opacity as needed
            BlendMode.srcOver,
          ),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(),
              SizedBox(
                height: Get.height * 0.05,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                            onTap: () {
                              Get.to(AudioUi());
                            },
                            child: CustomMenuBtn(
                                library: "Sound\nLibrary",
                                settingimage: AppAssets.settings1)),
                        GestureDetector(
                            onTap: () {
                              Get.to(const UploadScreen());
                            },
                            child: CustomMenuBtn(
                                library: "Video\nUpload",
                                settingimage: AppAssets.settings2)),
                                GestureDetector(
                            onTap: () {
                              Get.to(const ProfileScreen());
                            },
                            child: CustomMenuBtn(
                                library: "Profile\nSetup",
                                settingimage: AppAssets.settings4)),
                                
                        // GestureDetector(
                        //     onTap: () {
                        //       Get.to(AppStoreScreen());
                        //     },
                        //     child: CustomSettings(
                        //         library: "In-App\nStore",
                        //         settingimage: AppAssets.settings3)),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.040,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                        onTap: () {
                          Get.to(NewPrivacyScreen());
                        },
                        child: CustomMenuBtn(
                            library: "Privacy\nPolicy",
                            settingimage: AppAssets.proivacyPolicy)),
                        
                        GestureDetector(
                            onTap: () {
                              Get.to(const SocialScreen());
                            },
                            child: CustomMenuBtn(
                                library: "Social\nFeed",
                                settingimage: AppAssets.settings5)),
                        GestureDetector(
                            onTap: () {
                              Get.to(const TextScreen());
                            },
                            child: CustomMenuBtn(
                                library: "Safety\nInformation",
                                settingimage: AppAssets.settings6)),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.040,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[ 
                        GestureDetector(
                          onTap: () {
                           showSignOut(context);
                          },
                          child: CustomMenuBtn(
                              library: "Log Out",
                              settingimage: AppAssets.settings3)),
                        GestureDetector(
                          onTap: () {
                           deleteAccount(context);
                          },
                          child: CustomMenuBtn(
                              library: "Delete Account",
                              settingimage: AppAssets.delProfile)),]
                    ),
                    
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  void showSignOut(
    BuildContext context,
  ) {
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
          title: Text(
            "Do you want to sign out?",
            style: TextStyle(fontSize: 20, color: AppColors.whitecolor),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "cancel",
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 18),
                      )),
                  TextButton(
                    onPressed: () async {
                      await controller.GoogleSignOut();
                      await controller.facebookSignOut();
                      await controller.signOutApple();
                      appStorage.erase();
                      Get.offAll(LoginScreen());
                    },
                    child: Text(
                      "Log out",
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
  void deleteAccount(
    BuildContext context,
  ) {
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
          title: Text(
            "Do you want to Delete Your Account Permanently? ",textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: AppColors.whitecolor),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "cancel",
                        style: TextStyle(
                            color: AppColors.primaryColor, fontSize: 18),
                      )),
                  TextButton(
                    onPressed: () async {
                      await controller.deleteAccount();
                      await controller.GoogleSignOut();
                      await controller.facebookSignOut();
                      await controller.signOutApple();
                      appStorage.erase();
                      Get.offAll(LoginScreen());
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(
                          color: AppColors.primaryColor, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}





