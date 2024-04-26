import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/components/colors.dart';
import 'package:squeak/view/homescreen.dart';
import 'package:squeak/view/menu_screen.dart';

class CustomVideoAppbar extends StatelessWidget {
  final String midtext;

  CustomVideoAppbar({
    required this.midtext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25),
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
              child:Icon(Icons.home,color:AppColors.primaryColor,size:55)
            ),
          ),
          Text(
            midtext,
            style: TextStyle(
                fontSize: 30,
                color: AppColors.primaryColor,
                fontWeight: FontWeight.w700),
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
    );
  }
}