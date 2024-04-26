import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/view/homescreen.dart';
// import 'package:squeak/models/dumymodel5.dart';

import 'package:squeak/view/menu_screen.dart';
import 'colors.dart';

class CustomAppBar extends StatelessWidget {
  final bool show;
  const CustomAppBar({super.key,this.show=false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, top: 48),
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
          show?Text("") :CircleAvatar(
            backgroundColor: Colors.transparent,
            radius:55,
            backgroundImage:AssetImage(AppAssets.signin),
          

          ),
          // Container(
          //   height: Get.height * 0.09,
          //   width: Get.width * 0.3,
          //   decoration: BoxDecoration(
          //     shape:BoxShape.circle,
              
          //       image: DecorationImage(
                  
          //           image: AssetImage(AppAssets.signin), fit: BoxFit.fill)),
          // ),
          GestureDetector(
            onTap: () {
              Get.offAll(MenuScreen());
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





// final List<AudioModel> people = [
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   AudioModel(
//       audioUrl: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
//       title: "Song Title",
//       time: '3:21',
//       treats: 20,
//       download: Icon(
//         Icons.download,
//         color: Customitems.whitecolor,
//       ),
//       bin: Icon(Icons.delete_sharp, color: Customitems.whitecolor)),
//   // Add more people as needed
// ];



// final List<CommentModel> share = [
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
//   CommentModel(
//       username: "Syed Omer",
//       time: "20 Days ago",
//       comment: "Lorem Ipsum is a dumy text",
//       img: "assets/images/profile1.jpg"),
// ];
// final List<TreatModel> dollar = [
//   TreatModel(treats: "100", price: "\$20"),
//   TreatModel(treats: "200", price: "\$20"),
//   TreatModel(treats: "300", price: "\$20"),
//   TreatModel(treats: "400", price: "\$20"),
//   TreatModel(treats: "500", price: "\$20"),
//   TreatModel(treats: "600", price: "\$20"),
//   TreatModel(treats: "100", price: "\$20"),
//   TreatModel(treats: "200", price: "\$20"),
//   TreatModel(treats: "300", price: "\$20"),
//   TreatModel(treats: "400", price: "\$20"),
//   TreatModel(treats: "500", price: "\$20"),
//   TreatModel(treats: "600", price: "\$20"),
// ];

// final List<GridModel1> grid1 = [
//   GridModel1(
//       img: AppAssets.gridimg, title: "First dog", comment: "1", favourite: "5"),
//   GridModel1(
//       img: AppAssets.gridimg, title: "First dog", comment: "1", favourite: "5"),
//   GridModel1(
//       img: AppAssets.gridimg, title: "First dog", comment: "1", favourite: "5"),
//   GridModel1(
//       img: AppAssets.gridimg, title: "First dog", comment: "1", favourite: "5"),
//   GridModel1(
//       img: AppAssets.gridimg, title: "First dog", comment: "1", favourite: "5"),
// ];

// final List<AppModel> app = [
//   AppModel(img: AppAssets.appitem2, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem1, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem2, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem1, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem1, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem2, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem1, title: "Setgipping", price: "\$20"),
//   AppModel(img: AppAssets.appitem1, title: "Setgipping", price: "\$20"),
// ];



