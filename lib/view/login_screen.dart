import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/customButton.dart';
import 'package:squeak/components/customTextField.dart';
import 'package:squeak/components/custom_auth.dart';
import 'package:squeak/controller/auth_controller.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/view/forgot_screen.dart';
import 'package:squeak/view/register_screen.dart';
import '../components/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final textController=TextEditingController();
  AuthController controller = Get.put(AuthController());
  bool isChecked = false;
  final _emailValidator = RegExp(
    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$',
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
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
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const CustomContainer(),
                  SizedBox(height: Get.height * 0.05),
                  Text(
                    "Sign In",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 35,
                        color: AppColors.whitecolor),
                  ),
                  SizedBox(height: Get.height * 0.075),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hinttext: "Enter Email",
                          controller: emailController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!_emailValidator.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                          showSuffixIcon: false,
                        ),
                        SizedBox(height: Get.height * 0.016),
                        CustomTextField(
                          hinttext: "Enter Password",
                          controller: passwordController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length <= 4) {
                              return "Passsword Must greater than or equal to 4 ";
                            }
                            return null;
                          },
                          showSuffixIcon: true,
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: Get.height * 0.060,
                    width: Get.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(const ForgotScreen());
                          },
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(
                                fontSize: 12, color: AppColors.primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        controller.signInUser(
                            emailController.text, passwordController.text);
                      }
                    },
                    child: CustomButton(fieldname: "Sign In"),
                  ),
                  SizedBox(height: Get.height * 0.085),
                  GestureDetector(
                    onTap: () {
                      Get.to(const RegisterScreen());
                    },
                    child: Container(
                      height: Get.height * 0.022,
                      width: Get.width * 0.87,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You don’t have an account?",
                              style: TextStyle(
                                  fontSize: 12, color: AppColors.whitecolor),
                            ),
                            Text(
                              "Sign up",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryColor),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height * 0.015),
                  Container(
                    height: Get.height * 0.06,
                    width: Get.width * 0.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomAuth(
                            assetpath: AppAssets.facebook,
                            onTap: () {
                              controller.signInWithFacebook();
                            }),
                        SizedBox(
                          width: Get.width * 0.045,
                        ),
                        CustomAuth(assetpath: AppAssets.apple, onTap: () {
                          controller.signInWithApple();
                        }),
                        SizedBox(
                          width: Get.width * 0.05,
                        ),
                        CustomAuth(
                            assetpath: AppAssets.google,
                            onTap: () {
                              controller.signInWithGoogle();
                            })
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
