import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:squeak/view/FinalAudio.dart';
import 'package:squeak/view/audio_play_screen.dart';
import 'app_assets.dart';
import 'colors.dart';
import 'package:app_settings/app_settings.dart';

// ignore: must_be_immutable
class CustonPlayButton extends StatefulWidget {
  VoidCallback? playTap;
  VoidCallback? nextTap;
  VoidCallback? previousTap;
  Icon playIcon;

  CustonPlayButton(
      {super.key,
      required this.playTap,
      required this.previousTap,
      required this.playIcon,
      required this.nextTap});

  @override
  State<CustonPlayButton> createState() => _CustonPlayButtonState();
}

class _CustonPlayButtonState extends State<CustonPlayButton> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(AppAssets.watch),
      radius: 145,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 3, top: 32),
            child: GestureDetector(
              onTap: () async {
                // Check current Bluetooth permission status
                PermissionStatus status = await Permission.bluetooth.status;

                if (status.isGranted) {
                  // Inform the user that Bluetooth permission is already granted
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Bluetooth permission is already granted.')),
                  );
                } else if (status.isDenied || status.isRestricted || status.isLimited || status.isPermanentlyDenied) {
                  // Request Bluetooth permission
                  PermissionStatus result = await Permission.bluetooth.request();

                  if (result.isGranted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bluetooth permission granted.')),
                    );
                  } else if (result.isDenied || result.isPermanentlyDenied) {
                    // Open app settings
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
                            'Bluetooth Permission Required',
                            style: TextStyle(color: AppColors.whitecolor),
                          ),
                          content: Text(
                            'This app needs Bluetooth access to function properly. Please grant Bluetooth permission in the app settings.',
                            style: TextStyle(color: AppColors.whitecolor),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Continue',style: TextStyle(color: AppColors.whitecolor),),
                              onPressed: () {
                                Navigator.of(context).pop();
                                AppSettings.openAppSettings();
                              },
                            ),
                            TextButton(
                              child: Text('Cancel',style: TextStyle(color: AppColors.whitecolor),),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    // Handle other permission states (optional)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Bluetooth permission is required to proceed.')),
                    );
                  }
                } else {
                  // Handle other permission states (optional)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Unexpected permission status: $status')),
                  );
                }
              },
              child: Icon(
                Icons.bluetooth_rounded,
                size: 32,
                color: AppColors.buttoncolor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 23, top: 3),
                  child: GestureDetector(
                      onTap: widget.previousTap,
                      child: Icon(
                        Icons.skip_previous_rounded,
                        size: 40,
                        color: AppColors.buttoncolor,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 63, top: 2.5),
                  child: GestureDetector(onTap: widget.playTap, child: widget.playIcon),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 58),
                  child: GestureDetector(
                      onTap: widget.nextTap,
                      child: Icon(Icons.skip_next_rounded,
                          size: 40, color: AppColors.buttoncolor)),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 61, left: 1),
            child: GestureDetector(
                onTap: () {
                  Get.to(const AudioUi());
                },
                child: Icon(
                  Icons.format_list_bulleted,
                  size: 30,
                  color: AppColors.buttoncolor,
                  weight: 100,
                )),
          ),
        ],
      ),
    );
  }
}
