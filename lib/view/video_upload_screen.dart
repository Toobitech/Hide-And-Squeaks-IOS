import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/components/custom_video_appbar.dart';
import 'package:squeak/controller/video_controller.dart';
import 'package:squeak/models/video_model.dart';
import '../components/colors.dart';
import '../components/custom_snakbar.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  VideoController controller = Get.put(VideoController());

  bool isChecked = false;
  bool isChecked2 = false;
  String privacyOption = "";

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    titleController.clear();
    descriptionController.clear();
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
              Column(
                children: [
                  Stack(
                    children: [
                      Obx(
                        () => Container(
                          height: Get.height * 0.5,
                          width: Get.width * 1,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                  image: controller.thumbnailFile.value != null
                                      ? Image.file(
                                              controller.thumbnailFile.value!)
                                          .image
                                      : AssetImage(AppAssets.defaultimg),
                                  fit: BoxFit.cover)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: CustomVideoAppbar(midtext: "Upload"),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 10),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Title",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryColor),
                      ),
                    ),
                    TextFormField(
                      controller: titleController,
                      textAlign: TextAlign.start,
                      cursorColor: AppColors.whitecolor,
                      style: TextStyle(
                        color: AppColors.whitecolor,
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
                          hintText: "Enter Title of Your Video",
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.whitecolor, width: 1)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.whitecolor.withOpacity(0.7), width: 1),
                          ),
                          focusColor: Colors.transparent,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.whitecolor.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                          ),
                          constraints: BoxConstraints.tightFor(
                              height: Get.height * 0.035)),
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Description",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryColor),
                      ),
                    ),
                    TextFormField(
                      controller: descriptionController,
                      textAlign: TextAlign.start,
                      cursorColor: AppColors.whitecolor,
                      style: TextStyle(
                        color: AppColors.whitecolor,
                        fontSize: 17,
                      ),
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 10),
                          hintText: "Enter Description of Your Video",
                          border: InputBorder.none,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: AppColors.whitecolor, width: 1)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.whitecolor.withOpacity(0.7), width: 1),
                          ),
                          focusColor: Colors.transparent,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: AppColors.whitecolor.withOpacity(0.5),
                            fontWeight: FontWeight.normal,
                          ),
                          constraints: BoxConstraints.tightFor(
                              height: Get.height * 0.035)),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {});
                        print("pick video");

                        controller.pickVideo();
                      },
                      child: Stack(children: [
                        Container(
                          height: Get.height * 0.1,
                          width: Get.width * 0.89,
                          decoration:
                              const BoxDecoration(color: Colors.transparent),
                        ),
                        Positioned(
                          right: 0,
                          top: 11,
                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 40,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: Get.height * 0.067,
                            width: Get.width * 0.89,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primaryColor),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(width: Get.width*0.22,),
                                  Text(
                                    "Upload Video",
                                    style: TextStyle(
                                        color: AppColors.whitecolor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.1,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.file_upload_outlined,
                                      size: 50,
                                      weight: 50,
                                      color: AppColors.whitecolor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: Get.height * 0.05,
                    ),
                    GestureDetector(
                      onTap: () {
                        print("videopath:${controller.videofile.value}");
                        print("Privacy:  ${privacyOption}");
                        print(
                            "Thumbnailpath ${controller.thumbnailFile.value}");

                        if (controller.videofile.value != null &&
                            titleController.text.isNotEmpty &&
                            descriptionController.text.isNotEmpty &&
                            privacyOption.length > 2) {
                          var model = VideoModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              videotype: privacyOption,
                              thumbnail: controller.thumbnailFile.value!.path,
                              file_path: controller.videofile.value!.path);
                          controller.postVideo(model);
                          // titleController.clear();
                          // descriptionController.clear();
                        } else if (controller.videofile.value == null) {
                          showInSnackBar("Select a video to upload",
                              color: AppColors.errorcolor);
                        } else if (titleController.text.isEmpty) {
                          showInSnackBar("Enter Video Title",
                              color: AppColors.errorcolor);
                        } else if (descriptionController.text.isEmpty) {
                          showInSnackBar("Enter Video Descriptiion",
                              color: AppColors.errorcolor);
                        } else {
                          showInSnackBar("Select Video Type Private or Public",
                              color: AppColors.errorcolor);
                        }
                      },
                      child: Container(
                        height: Get.height * 0.055,
                        width: Get.width * 0.31,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(AppAssets.plublish),
                                fit: BoxFit.fill)),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              checkColor: AppColors.primaryColor,
                              activeColor: Colors.transparent,
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value ?? false;
                                  isChecked2 = !isChecked;
                                  privacyOption = "private";
                                });
                              },
                            ),
                            SizedBox(
                              width: Get.width * 0.03,
                            ),
                            Text(
                              "PRIVATE",
                              style: TextStyle(
                                  color: AppColors.whitecolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        Container(
                          height: Get.height * 0.037,
                          width: Get.width * 0.0000001,
                          decoration: BoxDecoration(
                              border: Border(
                                  right:
                                      BorderSide(color: AppColors.whitecolor))),
                        ),
                        Row(
                          children: [
                            Checkbox(
                              checkColor: AppColors.primaryColor,
                              activeColor: Colors.transparent,
                              value: isChecked2,
                              onChanged: (value) {
                                setState(() {
                                  isChecked2 = value ?? false;
                                  isChecked = !isChecked2;
                                  privacyOption = "public";
                                });
                              },
                            ),
                            Text(
                              "PUBLIC",
                              style: TextStyle(
                                  color: AppColors.whitecolor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
