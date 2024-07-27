import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';

class CustomAuth extends StatelessWidget {
  final String assetpath;
  final VoidCallback onTap;

  const CustomAuth({super.key, required this.assetpath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 23,
        backgroundImage: AssetImage(assetpath),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 0),
      child: 
      // Container(
      //   height: Get.height * 0.190,
      //   width: Get.width * 0.7,
      //   decoration: BoxDecoration(
      //     shape:BoxShape.circle,
      //       image: DecorationImage(
      //           image: AssetImage(AppAssets.signin), fit: BoxFit.fill)),
      // ),
      CircleAvatar(
        radius: 100,
        backgroundColor: Colors.transparent,
        backgroundImage: AssetImage(AppAssets.signin),
        
      )
    );
  }
}