import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/colors.dart';
import 'package:squeak/components/custom_appbar.dart';
import 'package:squeak/controller/treat_Controller.dart';
import 'package:squeak/view/NewPrivacy.dart';

class TextScreen extends StatefulWidget {
  final bool? privacy;
  const TextScreen({super.key,this.privacy});

  @override
  State<TextScreen> createState() => _TextScreenState();
}

class _TextScreenState extends State<TextScreen> {
  treatController controller=Get.put(treatController());



  @override
  void initState() {
    
    super.initState();
    controller.getPolicy();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
      body: Container(
        height: Get.height * 1,
        width: Get.width * 1,
        color: Colors.black,
        // decoration: BoxDecoration(
        //     image: DecorationImage(
        //         image: AssetImage(AppAssets.textback), fit: BoxFit.fill)),
        child: Padding(
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: Column(
            children: [
              const CustomAppBar(),
              SizedBox(height: Get.height * 0.01),
              
              
              Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Text(
                                          "Safety Guidelines for Using the Mobile App with Your Dog's Interactive Toy",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                                  fontSize: Get.width*0.065,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white ),
                                        ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            height: Get.height*0.62,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  MyText(firstText: "1. Monitor Your Dog: ", lastText: " Always keep an eye on your dog while they are playing with the interactive toy. This ensures their safety and prevents any potential accidents."),
                                                      MyText(firstText: "2. Regular Inspections: ", lastText: " Check the toy regularly for any signs of wear and tear. Replace the toy immediately if it shows any damage to avoid choking hazards."),
                                                      MyText(firstText: "3. Volume Control:", lastText: " Use the app to adjust the speaker volume to a comfortable level for your dog. Avoid setting it too loud to protect your dog's hearing."),
                                                      MyText(firstText: "4. Battery Safety:", lastText: " Ensure the toy’s batteries are properly secured and replace them as needed. Keep spare batteries out of reach of your pets."),
                                                      MyText(firstText: "5. App Updates:", lastText: " Regularly update the app to access the latest features and security improvements. This ensures optimal performance and safety."),
                                                      MyText(firstText: "6. Avoid Overuse:", lastText: " Limit the use of the interactive toy to prevent overstimulation and ensure your dog gets adequate rest."),
                                                      MyText(firstText: "7. Safe Environment:", lastText: " Use the toy in a safe, open area free from obstacles or hazards that your dog might bump into while playing."),
                                                      MyText(firstText: "7. Supervised Charging:", lastText: " Only charge the toy when your dog is not using it to avoid any electrical hazards."),
                                                      MyText(firstText: "", lastText: " By following these guidelines, you can ensure a fun and safe experience for your dog with their interactive toy. Enjoy the playful moments while keeping your furry friend’s well-being a top priority!")
                                            
                                  
                                ],
                              ),
                            ),
                          ),
                        )
                
                        
            ],
          ),
        ),
      ),
    );
  }
}
