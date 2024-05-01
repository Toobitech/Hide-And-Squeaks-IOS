import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/customButton.dart';
import 'package:squeak/components/customTextField.dart';
import 'package:squeak/components/custom_auth.dart';
import 'package:squeak/controller/auth_controller.dart';
import 'package:squeak/components/app_assets.dart';

import '../components/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  AuthController controller = Get.put(AuthController());

  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();

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
              AppColors.filtercolor, // Adjust opacity as needed
              BlendMode.srcOver,
            ),
          )),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  CustomContainer(),
                  SizedBox(height: Get.height * 0.057),
                  Text(
                    "Sign Up",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 35,
                        color: AppColors.whitecolor),
                  ),
                  SizedBox(height: Get.height * 0.060),
                  Form(
                    key: _formKey2,
                    child: Column(
                      children: [
                        CustomTextField(
                          hinttext: "First Name",
                          controller: firstNameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter FirstName';
                            }
                            
                            return null;
                          },
                          showSuffixIcon: false,
                        ),
                        SizedBox(height: Get.height * 0.016),
                        CustomTextField(
                          hinttext: "Last Name",
                          controller: lastNameController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter LastName';
                            }
                            // You can add more complex password validation logic here if needed
                            return null; // Return null if the input is valid
                          },
                          showSuffixIcon: false,
                        ),
                        SizedBox(height: Get.height * 0.016),
                        CustomTextField(
                            hinttext: "E-mail",
                            controller: emailController,
                            validator: (String? value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              } else if (!_emailValidator.hasMatch(value)) {
                                return 'Enter a valid email address';
                              }
                              return null;
                            },
                            showSuffixIcon: false),
                        SizedBox(height: Get.height * 0.016),
                        CustomTextField(
                          hinttext: "Password",
                          controller: signUpPasswordController,
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length <= 4) {
                              return "Passsword Must greater than or equal to 4 ";
                            }
                            return null;
                          },
                          showSuffixIcon: true,
                        ),
                        SizedBox(height: Get.height * 0.048),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey2.currentState?.validate() ?? false) {
                        controller.registerUser(
                          firstNameController.text,
                          lastNameController.text,
                          emailController.text,
                          signUpPasswordController.text,
                        );
                      }
                    },
                    child: CustomButton(fieldname: "Sign Up"),
                  ),
                  SizedBox(height: Get.height * 0.07),
                  Text("Sign In With",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor)),
                  SizedBox(height: Get.height * 0.012),
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
