import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/controller/profile_controller.dart';
import 'package:squeak/models/user_model.dart';
import '../components/colors.dart';
import '../components/custom_snakbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileController controller = Get.put(ProfileController());

 

  TextEditingController nameController = TextEditingController();
  TextEditingController breedController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.getUserProfile().then((_) {
      nameController =
          TextEditingController(text: controller.userDataList.value.petName);
      breedController =
          TextEditingController(text: controller.userDataList.value.petBreed);
    });
  }
   @override
  void dispose(){
    super.dispose();
    Get.delete<ProfileController>();
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
                  image: AssetImage(AppAssets.backgroundmain),
                  fit: BoxFit.fill)),
          child: SingleChildScrollView(
            child: Obx(
              () => Column(
                children: [
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: Get.width * 0.035,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Container(
                        width: Get.width * 0.15,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Container(
                        width: Get.width * 0.035,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 30,
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w800),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Container(
                        width: Get.width * 0.035,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Container(
                        width: Get.width * 0.15,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                      SizedBox(
                        width: Get.width * 0.02,
                      ),
                      Container(
                        width: Get.width * 0.035,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    color: AppColors.whitecolor, width: 2))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Container(
                    height: Get.height * 0.082,
                    width: Get.width * 0.85,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: AppColors.containercolor),
                    child: Center(
                      child: Container(
                        width: Get.width*0.8,
                        child: controller.isLoading.value?Center(child: CircularProgressIndicator(color: AppColors.primaryColor,)): Center(
                          child: Text(
                            controller.userDataList.value.petName.toString(),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w900,
                                fontSize: 35),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                  Container(
                    width: Get.width * 0.75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(30, (index) {
                        return Container(
                          height: Get.height * 0.022,
                          width: Get.width * 0.02,
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: AppColors.whitecolor,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.01,
                  ),
                  Stack(
                    children: [
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(AppAssets.back1),
                          radius: 140,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20, left: 1),
                            child: controller.isLoading.value
                                ? CircularProgressIndicator(
                                    color: AppColors.whitecolor,
                                  )
                                : CircleAvatar(
                                    radius: 88,
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: controller.image.value !=
                                            null
                                        ? Image.file(controller.image.value!)
                                            .image
                                        : controller.userDataList.value
                                                    .profile !=
                                                null
                                            ? Image.network(
                                                AppUrl.imageUrl +
                                                    controller.userDataList
                                                        .value.profile!,
                                              ).image
                                            : AssetImage(AppAssets.back2),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 150, top: 80),
                                      child: GestureDetector(
                                          onTap: () {},
                                          child: CircleAvatar(
                                              child: Image.asset(
                                                  AppAssets.back3))),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            print("pick image");

                            controller.pickImage();
                          },
                          child: Image.asset(AppAssets.back4))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Name",
                            style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 21,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.003,
                        ),
                        Container(
                          height: Get.height * 0.15,
                          width: Get.width * 0.85,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: AppColors.containercolor),
                          child: Column(
                            children: [
                              SizedBox(
                                height: Get.height * 0.018,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Name",
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.02,
                                  ),
                                  TextFormField(
                                    controller: nameController,
                                    textAlign: TextAlign.start,
                                    cursorColor: AppColors.primaryColor,
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                    ),
                                    decoration: InputDecoration(
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 7),
                                        hintText: "Enter Name",
                                        suffixIcon: Icon(
                                          Icons.do_not_disturb_on_rounded,
                                          color: AppColors.primaryColor,
                                          size: 8,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor,
                                                width: 3)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor,
                                              width:
                                                  3), // Change color as needed
                                        ),
                                        focusColor: Colors.transparent,
                                        hintStyle: TextStyle(
                                          fontSize: 17,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            width: Get.width * 0.55,
                                            height: Get.height * 0.035)),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: Get.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(left: 7),
                                    child: Text(
                                      "Bred",
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.05,
                                  ),
                                  TextFormField(
                                    controller: breedController,
                                    textAlign: TextAlign.start,
                                    cursorColor: AppColors.primaryColor,
                                    style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                    decoration: InputDecoration(
                                        hintText: "Enter Breed",
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 7, vertical: 7),
                                        suffixIcon: Icon(
                                          Icons.do_not_disturb_on_rounded,
                                          color: AppColors.primaryColor,
                                          size: 8,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.primaryColor,
                                                width: 3)),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: AppColors.primaryColor,
                                              width: 3),
                                        ),
                                        focusColor: Colors.transparent,
                                        hintStyle: TextStyle(
                                          fontSize: 17,
                                          color: AppColors.primaryColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        constraints: BoxConstraints.tightFor(
                                            width: Get.width * 0.55,
                                            height: Get.height * 0.035)),
                                  ),
                                ],
                              ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  Container(
                    height: Get.height * 0.1,
                    width: Get.width * 0.85,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(AppAssets.pet),
                            fit: BoxFit.fill)),
                  ),
                  SizedBox(
                    height: Get.height * 0.03,
                  ),
                  GestureDetector(
                    onTap: () async {
                      // print(controller.image.value!.path);

                      // checkimage() {
                      //   if (controller.image.value == null) {
                      //     print(controller.userDataList.value.profile);

                      //     return "";
                      //   } else {
                      //     print(controller.image.value.toString());
                      //     return controller.image.value!.path;
                      //   }
                      // }

                      if (controller.image.value != null &&
                          nameController.text.isNotEmpty &&
                          breedController.text.isNotEmpty) {
                        print("Obj1");
                        var model = userModel(
                            petName: nameController.text,
                            petBreed: breedController.text,
                            profile: controller.image.value!.path);

                        controller.postProfile(model);
                      } else if (controller.image.value == null &&
                          nameController.text.isNotEmpty &&
                          breedController.text.isNotEmpty) {
                        print("Obj-2");
                        var model = userModel(
                          petName: nameController.text,
                          petBreed: breedController.text,
                        );
                        controller.postProfile(model);
                      } else if (nameController.text.isEmpty) {
                        print("Obj-3");
                        showInSnackBar("Enter Pet Name",
                            color: AppColors.errorcolor);
                      } else {
                        print("Obj-4");
                        showInSnackBar("Enter Breed name",
                            color: AppColors.errorcolor);
                      }
                    },
                    child: Container(
                      height: Get.height * 0.068,
                      width: Get.width * 0.41,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(AppAssets.save),
                              fit: BoxFit.fill)),
                      child: Center(
                        child: Text(
                          "Save",
                          style: TextStyle(
                              fontSize: 30,
                              color: AppColors.whitecolor,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
