import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/components/custom_appbar.dart';

class RegisterPrivacy extends StatefulWidget {
  const RegisterPrivacy({super.key});

  @override
  State<RegisterPrivacy> createState() => _RegisterPrivacyState();
}

class _RegisterPrivacyState extends State<RegisterPrivacy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius:80,
            backgroundImage:AssetImage(AppAssets.signin),
          

          ),
         
          SizedBox(height: Get.height * 0.04),
          Center(
            child: Text(
              "Privacy and Terms",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: Get.width * 0.08,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.02),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildSectionTitle("Terms of Use"),
                      MyText(
                          firstText: "1. Acceptance of Terms:",
                          lastText: " By using this mobile app, you agree to comply with these terms of use. If you do not agree, please do not use the app."),
                      MyText(
                          firstText: "2. User Responsibility:",
                          lastText: " Users are responsible for ensuring the safety of their pets while using the app and the interactive toy. The app should be used as intended."),
                      MyText(
                          firstText: "3. App Updates:",
                          lastText: " We reserve the right to update or modify the app at any time. Users are encouraged to update the app regularly for the best experience."),
                      MyText(
                          firstText: "4. Limitation of Liability:",
                          lastText: " We are not liable for any damages or injuries that occur from the use of the app or the interactive toy."),
                      MyText(
                          firstText: "5. Termination:",
                          lastText: " We reserve the right to terminate access to the app at our discretion, without notice, for conduct that we believe violates these terms or is harmful to other users."),
                      SizedBox(height: Get.height * 0.035),
                      _buildSectionTitle("Privacy Policy"),
                      MyText(
                          firstText: "1. Data Collection:",
                          lastText: " We collect data to improve the app's performance and user experience. This includes usage data, device information, and user feedback."),
                      MyText(
                          firstText: "2. Use of Data:",
                          lastText: " The data collected is used to enhance app functionality, provide customer support, and communicate updates or offers."),
                      MyText(
                          firstText: "3. Data Sharing:",
                          lastText: " We do not share your personal data with third parties except as required by law or to protect our rights."),
                      MyText(
                          firstText: "4. Security:",
                          lastText: " We implement appropriate security measures to protect your data from unauthorized access or disclosure."),
                      MyText(
                          firstText: "5. User Rights:",
                          lastText: " Users have the right to access, modify, or delete their personal data. Contact us for any data-related requests."),
                      MyText(
                          firstText: "6. Changes to Policy:",
                          lastText: " We may update this privacy policy periodically. Users will be notified of significant changes."),
                      MyText(
                          firstText: "7. Agreement to policy",
                          lastText: " By using this app, you agree to these terms and our privacy policy. For any questions, please contact our support team."),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Get.width * 0.065,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class MyText extends StatelessWidget {
  final String firstText;
  final String lastText;

  MyText({required this.firstText, required this.lastText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: Get.width * 0.05,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
          children: <TextSpan>[
            TextSpan(text: firstText),
            TextSpan(
              text: lastText,
              style: TextStyle(
                fontSize: Get.width * 0.035,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
