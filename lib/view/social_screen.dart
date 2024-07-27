import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/controller/video_controller.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/models/video_model.dart';
import 'package:squeak/view/privateScreen.dart';
import '../components/colors.dart';

class SocialTabScreen extends StatefulWidget {
  const SocialTabScreen({super.key});

  @override
  _SocialTabScreenState createState() => _SocialTabScreenState();
}

class _SocialTabScreenState extends State<SocialTabScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isLoadingvideo = true;

  VideoController controller = Get.put(VideoController());

  @override
  void initState() {
    super.initState();
    controller.Getvideo();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Get.height * 0.055),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Center(
                child: Container(
                  height: Get.height * 0.052,
                  width: Get.width * 0.55,
                  decoration:
                  
                      BoxDecoration(
                       
                        borderRadius: BorderRadius.circular(5)),
                  child: const Tab(text: 'Social Feed'),
                ),
              ),
              Container(
                height: Get.height * 0.052,
                width: Get.width * 0.55,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: const Tab(text: 'Private'),
              ),
            ],
            indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color:
                    const Color(0xff4A330D).withOpacity(0.70)
                ),
            labelColor: AppColors.whitecolor,
            labelStyle: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.w800, letterSpacing: 1.25),
            unselectedLabelStyle: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.85),
            unselectedLabelColor: AppColors.whitecolor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 13),
        child: Container(
          color: Colors.transparent,
          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.1,
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : controller.videoListpublic.isEmpty
                            ? Center(
                                child: Text(
                                  'No Video Here',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount: controller.videoListpublic.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, int index) {
                                  VideoModel video =
                                      controller.videoListpublic[index];

                                  return GestureDetector(
                                    onTap: () {
                                      print("View Video");
                                      controller.Addview(video.id!);
                                      print("VideoID:${video.id}");
                                      controller.ViewData(video.id!);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.textfieldcolor,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(AppUrl.imageUrl +
                                              video.thumbnail.toString()),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 8,left: 8,bottom: 0,right: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Container(
                                                      height:
                                                          Get.height * 0.022,
                                                      width: Get.width * 0.05,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image: AssetImage(
                                                              AppAssets
                                                                  .commentimg),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.01,
                                                    ),
                                                    Text(
                                                      video.totalComments
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .whitecolor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      video.totalLikes
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .whitecolor,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Get.width * 0.01,
                                                    ),
                                                    Icon(
                                                      Icons.favorite,
                                                      color: AppColors
                                                          .favouritecolor,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.11,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: SizedBox(
                                                    child: Text(
                                                      video.title.toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .whitecolor,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          fontSize: 23,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  )),
              Container(
                  height: Get.height * 0.2,
                  width: Get.width * 0.1,
                  child: Obx(
                    () => controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                            ),
                          )
                        : controller.videoListprivate.isEmpty
                            ? Center(
                                child: Text(
                                  'NO private videos',
                                  style:
                                      TextStyle(color: AppColors.primaryColor),
                                ),
                              )
                            : GridView.builder(
                                itemCount: controller.videoListprivate.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisSpacing: 20,
                                  mainAxisSpacing: 20,
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (context, int index) {
                                  VideoModel video =
                                      controller.videoListprivate[index];

                                  return GestureDetector(
                                    onTap: () {
                                      print(
                                          "file_path:${AppUrl.videoURL + video.file_path.toString()}");

                                      Get.to(PrivateScreen(
                                          link: video.file_path.toString(),
                                          title: video.title.toString()));
                                      // controller.ViewData(video.id);
                                      // controller.Addview(video.id);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.textfieldcolor,
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          image: NetworkImage(AppUrl.imageUrl +
                                              video.thumbnail.toString()),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 15),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.bottomLeft,
                                                  child: SizedBox(
                                                    width: Get.width * 0.3,
                                                    child: Text(
                                                      video.title.toString(),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      softWrap: false,
                                                      style: TextStyle(
                                                        color: AppColors
                                                            .whitecolor,
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  behavior: HitTestBehavior
                                                      .translucent,
                                                  onTap: () {
                                                    showDeleteBox(context,
                                                        videoId: video.id!,
                                                        number: controller
                                                                .videoListprivate[
                                                            index]);

                                                    print(
                                                        "videoid: ${video.id}");
                                                    // controller.videoListprivate.remove(controller.videoListprivate[index]);
                                                    // controller.deleteVideo(video.id!);
                                                  },
                                                  child: Container(
                                                    height: Get.height * 0.03,
                                                    width: Get.width * 0.045,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: AssetImage(
                                                            AppAssets.delimg),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void showDeleteBox(BuildContext context,
      {required int videoId, required VideoModel number}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(color: AppColors.whitecolor, width: 1),
          ),
          title: Center(
              child: Text(
            "${number.title} ",
            style: TextStyle(color: AppColors.whitecolor, fontSize: 24),
          )),
          content: Text(
            "Do you want to delete this video ?",
            style: TextStyle(color: AppColors.whitecolor, fontSize: 16.5),
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.videoListprivate.remove(number);
                controller.deleteVideo(videoId);
                Get.back();
              },
              child: Text(
                "OK",
                style: TextStyle(color: AppColors.primaryColor, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}
