// // import 'package:flutter/material.dart';
// // import 'package:squeak/models/dumymodel5.dart';
// // import 'package:squeak/components/app_assets.dart';
// // import 'package:get/get.dart';
// // import 'package:squeak/components/custom.dart';

// // import '../components/colors.dart';

// // class AppStoreScreen extends StatefulWidget {
// //   const AppStoreScreen({super.key});

// //   @override
// //   State<AppStoreScreen> createState() => _AppStoreScreenState();
// // }

// // class _AppStoreScreenState extends State<AppStoreScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //         body: Container(
// //       height: Get.height * 1,
// //       width: Get.width * 1,
// //       decoration: BoxDecoration(
// //           image: DecorationImage(
// //         image: AssetImage(AppAssets.menuback),
// //         fit: BoxFit.fill,
// //         colorFilter: ColorFilter.mode(
// //           AppColors.filtercolor, // Adjust opacity as needed
// //           BlendMode.srcOver,
// //         ),
// //       )),
// //       child: Column(
// //         children: [
// //           Customhead(),
// //           SizedBox(
// //             height: Get.height * 0.02,
// //           ),
// //           Container(
// //             height: Get.height * 0.055,
// //             width: Get.width * 0.95,
// //             decoration: BoxDecoration(
// //                 image: DecorationImage(
// //                     image: AssetImage(AppAssets.appstoreimg),
// //                     fit: BoxFit.fill)),
// //             child: Center(
// //                 child: Padding(
// //               padding: EdgeInsets.only(top: 10),
// //               child: Text(
// //                 "In App Store",
// //                 style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w800),
// //               ),
// //             )),
// //           ),
// //           Expanded(
// //             child: Container(
// //               height: Get.height * 0.7,
// //               width: Get.width * 0.75,
// //               child: GridView.builder(
// //                 // Required properties
// //                 itemCount: app.length, // Number of items to display
// //                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
// //                     crossAxisSpacing: 10,
// //                     mainAxisSpacing: 0,
// //                     crossAxisCount: 2,
// //                     childAspectRatio: 3 / 4 // Number of items per row
// //                     ),
// //                 itemBuilder: (context, int index) {
// //                   AppModel item = app[index];
// //                   // Build each grid item
// //                   return Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Container(
// //                         height: Get.height * 0.165,
// //                         width: Get.width * 0.36,
// //                         decoration: BoxDecoration(
// //                             image: DecorationImage(
// //                                 image: AssetImage(item.img), fit: BoxFit.fill)),
// //                       ),
// //                       Container(
// //                         height: Get.height * 0.026,
// //                         child: Text(
// //                           item.title,
// //                           style: TextStyle(
// //                               fontSize: 14,
// //                               fontWeight: FontWeight.w700,
// //                               color: AppColors.whitecolor),
// //                         ),
// //                       ),
// //                       Container(
// //                         height: Get.height * 0.025,
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                           children: [
// //                             Row(
// //                               children: [
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: AppColors.primaryColor,
// //                                   size: 20,
// //                                 ),
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: AppColors.primaryColor,
// //                                   size: 20,
// //                                 ),
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: AppColors.primaryColor,
// //                                   size: 20,
// //                                 ),
// //                                 Icon(
// //                                   Icons.star,
// //                                   color: AppColors.primaryColor,
// //                                   size: 20,
// //                                 ),
// //                               ],
// //                             ),
// //                             Text(
// //                               item.price,
// //                               style: TextStyle(
// //                                   fontSize: 15,
// //                                   fontWeight: FontWeight.w700,
// //                                   color: AppColors.whitecolor),
// //                             )
// //                           ],
// //                         ),
// //                       )
// //                     ],
// //                   );
// //                 },
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     ));
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:squeak/view/FinalAudio.dart';
// import 'package:squeak/view/audio_play_screen.dart';
// import 'app_assets.dart';
// import 'colors.dart';
// import 'package:app_settings/app_settings.dart';


// // ignore: must_be_immutable
// class CustonPlayButton extends StatefulWidget {
//   VoidCallback? playTap;
//   VoidCallback? nextTap;
//   VoidCallback? previousTap;
//   Icon playIcon;

//   CustonPlayButton(
//       {super.key, required this.playTap,
//       required this.previousTap,
//       required this.playIcon,
//       required this.nextTap});
      

//   @override
//   State<CustonPlayButton> createState() => _CustonPlayButtonState();
// }



// class _CustonPlayButtonState extends State<CustonPlayButton> {
//   // bool _bluetoothSettingsOpened = false;
//   // Connectivity connectivity = Connectivity();
//   // AudioPlayer _audioPlayer = AudioPlayer();
//   // ConnectivityResult connectivityResult = ConnectivityResult.none;


  


// //     Future<void> _checkBluetoothSettings() async {
// //   SystemChannels.lifecycle.setMessageHandler((message) async {
// //     if (message == AppLifecycleState.resumed.toString()) {
// //       // Check if Bluetooth settings were opened
// //       if (_bluetoothSettingsOpened) {
// //         print("get back from settings");
// //         // Check Bluetooth connectivity
// //         final connectivityResult =await (Connectivity().checkConnectivity());
// //         if (connectivityResult== ConnectivityResult.bluetooth) {
// //           print("connectivity");
// //           // If Bluetooth connection is detected, play sound
// //           _playSound();
// //         }
// //         // Show Snackbar
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(
// //             content: Text('Returned from Bluetooth settings'),
// //           ),
// //         );
// //         // Reset the flag
// //         _bluetoothSettingsOpened = false;
// //       }
// //     }
// //     return null;
// //   });
// // }

// //    _playSound() async {
// //   print("sound checking");
// //   // Play sound using AudioPlayer
// //   _audioPlayer.play(AssetSource("images/flutter.mp3"));
// // }
// //   @override
// //   void initState() {
// //     super.initState();
    
// //     _checkBluetoothSettings();
// //   }


//   @override
//   Widget build(BuildContext context) {
//     return CircleAvatar(
//       backgroundColor: Colors.transparent,
//       backgroundImage: AssetImage(AppAssets.watch),
//       radius: 145,
//       child: Column(
//         children: [
//         Padding(
//       padding: const EdgeInsets.only(left: 3, top: 32),
//       child: GestureDetector(
//         onTap: () async {
//           // Check current Bluetooth permission status
//           PermissionStatus status = await Permission.bluetooth.status;

//           if (status.isDenied || status.isRestricted || status.isLimited) {
//             // Show a dialog explaining why the permission is needed
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   backgroundColor: Colors.black,
//                   title: Text(
//                     'Bluetooth Permission Required',
//                     style: TextStyle(color: AppColors.whitecolor),
//                   ),
//                   content: Text(
//                     'This app needs Bluetooth access to function properly. Please grant Bluetooth permission.',
//                     style: TextStyle(color: AppColors.whitecolor),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: Text('Cancel'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Grant Permission'),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         // Request Bluetooth permission
//                         PermissionStatus result = await Permission.bluetooth.request();
//                         if (result.isGranted) {
//                           // Open Bluetooth settings if permission is granted
//                           AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
//                         } else if (result.isPermanentlyDenied) {
//                           // Show dialog to direct user to app settings
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AlertDialog(
//                                 backgroundColor: Colors.black,
//                                 title: Text(
//                                   'Bluetooth Permission Permanently Denied',
//                                   style: TextStyle(color: AppColors.whitecolor),
//                                 ),
//                                 content: Text(
//                                   'Bluetooth permission has been permanently denied. Please enable it from the app settings.',
//                                   style: TextStyle(color: AppColors.whitecolor),
//                                 ),
//                                 actions: <Widget>[
//                                   TextButton(
//                                     child: Text('Open Settings'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                       openAppSettings();
//                                     },
//                                   ),
//                                   TextButton(
//                                     child: Text('Cancel'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               );
//                             },
//                           );
//                         } else {
//                           // Show a message if permission is denied
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Bluetooth permission is required to open settings')),
//                           );
//                         }
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else if (status.isGranted) {
//             // Open Bluetooth settings if permission is already granted
//             AppSettings.openAppSettings(type: AppSettingsType.bluetooth);
//           } else if (status.isPermanentlyDenied) {
//             // Show dialog to direct user to app settings
//             showDialog(
//               context: context,
//               builder: (BuildContext context) {
//                 return AlertDialog(
//                   backgroundColor: Colors.black,
//                   title: Text(
//                     'Bluetooth Permission Permanently Denied',
//                     style: TextStyle(color: AppColors.whitecolor),
//                   ),
//                   content: Text(
//                     'Bluetooth permission has been permanently denied. Please enable it from the app settings.',
//                     style: TextStyle(color: AppColors.whitecolor),
//                   ),
//                   actions: <Widget>[
//                     TextButton(
//                       child: Text('Open Settings'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                         openAppSettings();
//                       },
//                     ),
//                     TextButton(
//                       child: Text('Cancel'),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else {
//             // Handle other permission states (optional)
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(content: Text('Unexpected permission status: $status')),
//             );
//           }
//         },
//         child: Icon(
//           Icons.bluetooth_rounded,
//           size: 32,
//           color: AppColors.buttoncolor,
//         ),
//       ),
//     ),
//           Padding(
//             padding: const EdgeInsets.only(top: 55),
//             child: Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 23, top: 3),
//                   child: GestureDetector(
//                       onTap: widget.previousTap,
//                       child: Icon(
//                         Icons.skip_previous_rounded,
//                         size: 40,
//                         color: AppColors.buttoncolor,
//                       )),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 63, top: 2.5),
//                   child: GestureDetector(onTap: widget.playTap, child: widget.playIcon
//                       // Icon(
//                       //     indexPlaying ? Icons.pause : Icons.play_arrow_rounded,
//                       //     size: 42,
//                       //     color: AppColors.buttoncolor)
//                       ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 58),
//                   child: GestureDetector(
//                       onTap: widget.nextTap,
//                       child: Icon(Icons.skip_next_rounded,
//                           size: 40, color: AppColors.buttoncolor)),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 61, left: 1),
//             child: GestureDetector(
//                 onTap: () {
//                   // Get.to(const AudioPlayScreen());
//                    Get.to(const AudioUi());
                  
//                 },
//                 child: Icon(
//                   Icons.format_list_bulleted,
//                   size: 30,
//                   color: AppColors.buttoncolor,
//                   weight: 100,
//                 )),
//           ),
//         ],
//       ),
//     );
//   }
// }
