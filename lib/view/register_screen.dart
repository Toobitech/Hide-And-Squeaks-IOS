import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:squeak/components/customButton.dart';
import 'package:squeak/components/customTextField.dart';
import 'package:squeak/components/custom_auth.dart';
import 'package:squeak/components/custom_snakbar.dart';
import 'package:squeak/controller/auth_controller.dart';
import 'package:squeak/components/app_assets.dart';
import 'package:squeak/view/NewPrivacy.dart';
import 'package:squeak/view/registerPrivacy.dart';
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

  bool _acceptedTerms = false;

  void _registerUser() {
    if (_formKey2.currentState?.validate() ?? false) {
      if (_acceptedTerms) {
        controller.registerUser(
          firstNameController.text,
          lastNameController.text,
          emailController.text,
          signUpPasswordController.text,
        );
      } else {
        showInSnackBar('You must accept the terms and conditions to register.',color: AppColors.errorcolor);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: Get.height,
        width: Get.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.backgroundimage1),
            fit: BoxFit.fill,
            colorFilter: ColorFilter.mode(
              AppColors.filtercolor,
              BlendMode.srcOver,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomContainer(),
                SizedBox(height: Get.height * 0.035),
                Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 35,
                    color: AppColors.whitecolor,
                  ),
                ),
                SizedBox(height: Get.height * 0.05),
                Form(
                  key: _formKey2,
                  child: Column(
                    children: [
                      CustomTextField(
                        hinttext: "First Name",
                        controller: firstNameController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter First Name';
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
                            return 'Please enter Last Name';
                          }
                          return null;
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
                        showSuffixIcon: false,
                      ),
                      SizedBox(height: Get.height * 0.016),
                      CustomTextField(
                        hinttext: "Password",
                        controller: signUpPasswordController,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          } else if (value.length <= 4) {
                            return "Password must be greater than or equal to 4";
                          }
                          return null;
                        },
                        showSuffixIcon: true,
                      ),
                      SizedBox(height: Get.height * 0.025),
                      CheckboxListTile(
                        title: GestureDetector(
                          onTap: () {
                            Get.to(() => RegisterPrivacy());
                          },
                          child: Text(
                            'I agree to the Terms and Policy',
                            style: TextStyle(color: AppColors.whitecolor),
                          ),
                        ),
                        value: _acceptedTerms,
                        activeColor: AppColors.textfieldcolor,
                        onChanged: (bool? value) {
                          setState(() {
                            _acceptedTerms = value ?? false;
                          });
                        },
                      ),
                      GestureDetector(
                        onTap: _registerUser,
                        child: CustomButton(fieldname: "Sign Up"),
                      ),
                      SizedBox(height: Get.height * 0.045),
                      Text(
                        "Sign In With",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primaryColor,
                        ),
                      ),
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
                              },
                            ),
                            SizedBox(width: Get.width * 0.045),
                            CustomAuth(
                              assetpath: AppAssets.apple,
                              onTap: () {
                                controller.signInWithApple();
                              },
                            ),
                            SizedBox(width: Get.width * 0.05),
                            CustomAuth(
                              assetpath: AppAssets.google,
                              onTap: () {
                                controller.signInWithGoogle();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
