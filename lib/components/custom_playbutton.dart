
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
      {super.key, required this.playTap,
      required this.previousTap,
      required this.playIcon,
      required this.nextTap});
      

  @override
  State<CustonPlayButton> createState() => _CustonPlayButtonState();
}



class _CustonPlayButtonState extends State<CustonPlayButton> {
  // bool _bluetoothSettingsOpened = false;
  // Connectivity connectivity = Connectivity();
  // AudioPlayer _audioPlayer = AudioPlayer();
  // ConnectivityResult connectivityResult = ConnectivityResult.none;


  


//     Future<void> _checkBluetoothSettings() async {
//   SystemChannels.lifecycle.setMessageHandler((message) async {
//     if (message == AppLifecycleState.resumed.toString()) {
//       // Check if Bluetooth settings were opened
//       if (_bluetoothSettingsOpened) {
//         print("get back from settings");
//         // Check Bluetooth connectivity
//         final connectivityResult =await (Connectivity().checkConnectivity());
//         if (connectivityResult== ConnectivityResult.bluetooth) {
//           print("connectivity");
//           // If Bluetooth connection is detected, play sound
//           _playSound();
//         }
//         // Show Snackbar
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Returned from Bluetooth settings'),
//           ),
//         );
//         // Reset the flag
//         _bluetoothSettingsOpened = false;
//       }
//     }
//     return null;
//   });
// }

//    _playSound() async {
//   print("sound checking");
//   // Play sound using AudioPlayer
//   _audioPlayer.play(AssetSource("images/flutter.mp3"));
// }
//   @override
//   void initState() {
//     super.initState();
    
//     _checkBluetoothSettings();
//   }


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
                    //  bool result = await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);

                  // await AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                  AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
                  // Open Bluetooth settings using flutter_app_settings package
         
            // Set the flag to true indicating Bluetooth settings were opened
            // _bluetoothSettingsOpened = true;
            
            // Show Snackbar if the user returns from Bluetooth settings
            
                 
                },
                child: Icon(
                  Icons.bluetooth_rounded,
                  size: 32,
                  color: AppColors.buttoncolor,
                )),
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
                  child: GestureDetector(onTap: widget.playTap, child: widget.playIcon
                      // Icon(
                      //     indexPlaying ? Icons.pause : Icons.play_arrow_rounded,
                      //     size: 42,
                      //     color: AppColors.buttoncolor)
                      ),
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
                  // Get.to(const AudioPlayScreen());
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
