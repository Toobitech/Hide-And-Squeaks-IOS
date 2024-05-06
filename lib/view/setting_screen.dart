import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/controller/auth_controller.dart';

import 'package:squeak/view/homescreen.dart';
import 'package:squeak/view/login_screen.dart';
import 'package:squeak/view/menu_screen.dart';
import 'package:squeak/view/profile_screen.dart';

import '../components/colors.dart';
import 'package:app_settings/app_settings.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                image: AssetImage(AppAssets.bluetoothbackground),
                fit: BoxFit.fill)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25, top: 35),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(HomeScreen());
                    },
                    child: Container(
                      height: Get.height * 0.069,
                      width: Get.width * 0.15,
                      child: Icon(Icons.home,color:AppColors.primaryColor,size:55)
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(MenuScreen());
                    },
                    child: Container(
                        height: Get.height * 0.08,
                        width: Get.width * 0.12,
                        child: Icon(
                          Icons.menu_rounded,
                          color: AppColors.primaryColor,
                          size: 50,
                        )),
                  )
                ],
              ),
            ),
            Text(
              "Settings",
              style: TextStyle(
                  fontSize: 37,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor),
            ),
            SizedBox(
              height: Get.height * 0.28,
            ),
            Container(
              height: Get.height * 0.09,
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: AppColors.whitecolor))),
              child: Row(
                children: [
                  Container(
                    height: Get.height * 0.055,
                    width: Get.width * 0.12,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.bluetooth),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      AppSettings.openAppSettings(
                          type: AppSettingsType.bluetooth);
                    },
                    child: Text(
                      "Bluetooth",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whitecolor),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: Get.height * 0.09,
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: AppColors.whitecolor))),
              child: Row(
                children: [
                  Container(
                    height: Get.height * 0.055,
                    width: Get.width * 0.14,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.wifi),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      // Get.to(BalanceScreen());
                    },
                    child: Text(
                      "Legal",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whitecolor),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: Get.height * 0.09,
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: AppColors.whitecolor))),
              child: Row(
                children: [
                  Container(
                    height: Get.height * 0.055,
                    width: Get.width * 0.12,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.bluetoothlast),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(ProfileScreen());
                    },
                    child: Text(
                      "Profile",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whitecolor),
                    ),
                  )
                ],
              ),
            ),
            Container(
              height: Get.height * 0.09,
              width: Get.width * 0.7,
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: AppColors.whitecolor))),
              child: Row(
                children: [
                  Icon(
                    Icons.logout,
                    color: AppColors.whitecolor,
                    size: 45,
                  ),
                  SizedBox(
                    width: Get.width * 0.05,
                  ),
                  GestureDetector(
                    onTap: () async {
                      showSignOut(context);
                      // await controller.GoogleSignOut();
                      // await controller.facebookSignOut();

                      // appStorage.erase();
                      //  Get.offAll(LoginScreen());
                    },
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.whitecolor),
                    ),
                  )
                ],
              ),
            ),
          ],
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
}
