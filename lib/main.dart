
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:squeak/view/FinalAudio.dart';
import 'package:squeak/view/audioUI.dart';
import 'package:squeak/view/audio_play_screen.dart';
import 'package:squeak/view/newAudioTest.dart';
import 'package:squeak/view/testing.dart';
import 'components/custom_snakbar.dart';
import 'view/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    // Include other orientations if necessary
  ]);
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      home:SplashScreen(),
    );
  }
}
