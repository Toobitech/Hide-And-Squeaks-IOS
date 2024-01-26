import 'package:flutter/material.dart';
import 'package:squeak/controller/treat_Controller.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:get/get.dart';
import 'package:squeak/components/custom.dart';
import 'package:squeak/view/treat.dart';

import '../components/colors.dart';
import '../models/treatmodel.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  treatController controller = Get.put(treatController());
  @override
  void initState() {
    super.initState();
    Get.put(treatController());
    

    controller.fetchTreats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height * 1,
        width: Get.width * 1,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage(AppAssets.backgroundimage1),
          fit: BoxFit.fill,
          colorFilter: ColorFilter.mode(
            AppColors.filtercolor, 
            BlendMode.srcOver,
          ),
        )),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Customhead(),
              Container(
                height: Get.height * 0.83,
                width: Get.width * 0.82,
                color: Colors.transparent,
                child:Obx(()=> controller.isLoading.value?
                  Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ): ListView.builder(
                    itemCount: controller.treatList.length,
                    itemBuilder: (context, int index) {
                      TreatModel treat = controller.treatList[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 40),
                        child: Container(
                          height: Get.height * 0.16,
                          width: Get.width * 0.8,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  image: AssetImage(AppAssets.dollarback),
                                  fit: BoxFit.fill)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              CircleAvatar(
                                radius: 47,
                                child: Image.asset(AppAssets.treats),
                              ),
                              Container(
                                height: Get.height * 0.105,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            treat.treats.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 7),
                                            child: Text(
                                              "Treats",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 20,
                                                  color:
                                                      AppColors.primaryColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                     Text(
                                      treat.price.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(TreatScreen6(treat: treat));
                                      },
                                      child: Container(
                                          height: Get.height * 0.03,
                                          width: Get.width * 0.31,
                                          decoration: BoxDecoration(
                                              color: Color(0xffFF0000),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                            child: Text(
                                              "Purchase",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 18,
                                                  color: Colors.white),
                                            ),
                                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}