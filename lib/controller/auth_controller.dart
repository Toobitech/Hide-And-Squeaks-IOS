import 'dart:io';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/global/alertbox.dart';
import 'package:squeak/view/BlockUserScreen';
import 'package:squeak/view/OTP_screen.dart';
import 'package:squeak/view/homescreen.dart';
import 'package:squeak/view/password_screen.dart';
import 'package:squeak/view/login_screen.dart';
import '../components/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import '../components/custom_snakbar.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class AuthController extends GetxController {

  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    user.bindStream(auth.authStateChanges());
  }
  

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        //  showDialogue();

        User? currentUser = FirebaseAuth.instance.currentUser;
        String userEmail = currentUser?.email ?? '';
        String userDisplayName = currentUser?.displayName ?? '';

        List<String> nameParts = userDisplayName.split(' ');
        String userFirstName = nameParts[0];
        String userLastName = nameParts.length > 1 ? nameParts[1] : '';
        print(userEmail);
        print(userFirstName);
        print(userLastName);

        String randomPassword = "toobitechsqueaks";
        print(randomPassword);

        isUserRegistered() {
          if (userCredential.additionalUserInfo?.isNewUser == false) {
            print("Logincall");

            return signInUser(userEmail, randomPassword);
          } else {
            print("Registration called");

            return registerUser(
                userFirstName, userLastName, userEmail, randomPassword);
          }
        }   
        isUserRegistered();
      }
    } catch (e) {
      Get.back();
      showInSnackBar("Error While Authentcation${e}",
          color: AppColors.errorcolor);           
      print(e.toString());
    }
  }
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  signInWithApple() async {
    try {
      String clientID = 'com.toobitech.squeak-service';

      /// Now you have to put the redirectURL which you received from Glitch Server
      /// make sure you only copy the part till "https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/"
      /// and append the following part to it "callbacks/sign_in_with_apple"
      ///
      /// It will look something like this
      /// https://<GLITCH PROVIDED UNIQUE NAME>.glitch.me/callbacks/sign_in_with_apple
      String redirectURL =
          'https://far-verbena-jumpsuit.glitch.me/callbacks/sign_in_with_apple';

      /// Generates a Random String from 1-9 and A-Z characters.
      final rawNonce = generateNonce();

      /// We are converting that rawNonce into SHA256 for security purposes
      /// In our login.
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        /// Scopes are the values that you are requiring from
        /// Apple Server.
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: Platform.isIOS ? nonce : null,

        /// We are providing Web Authentication for Android Login,
        /// Android uses web browser-based login for Apple.
        webAuthenticationOptions: Platform.isIOS
            ? null
            : WebAuthenticationOptions(
                clientId: clientID,
                redirectUri: Uri.parse(redirectURL),
              ),
      );

      final AuthCredential appleAuthCredential =
          OAuthProvider('apple.com').credential(
        idToken: appleCredential.identityToken,
        rawNonce: Platform.isIOS ? rawNonce : null,
        accessToken: Platform.isIOS ? null : appleCredential.authorizationCode,
      );

      /// Once you are successful in generating Apple Credentials,
      /// We pass them into the Firebase function to finally sign in.
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(appleAuthCredential);

      var currentUser = FirebaseAuth.instance.currentUser;
      String userEmail = currentUser?.email ?? '';
      String userDisplayName = currentUser?.displayName ?? 'Apple User';

      List<String> nameParts = userDisplayName.split(' ');
      String userFirstName = nameParts[0];
      String userLastName = nameParts.length > 1 ? nameParts[1] : '';
      print(userEmail);
      print(userFirstName);
      print(userLastName);

//Split the Email
      String extractNameFromEmail(String email) {
        RegExp regex = RegExp(r'(.+?)(?=\d*@)');
        Match? match = regex.firstMatch(email)
;
        if (match != null) {
          return match.group(1)!;
        }
        return ''; // Return an empty string if no match is found
      }

      String randomPassword = "toobitechsqueaks";
      print(randomPassword);

      // Check if the user is new
      bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

      if (isNewUser) {
        String name = extractNameFromEmail(userEmail);
        print('Get name form Apple Account');
        print(name);
        await registerUser(userFirstName, userLastName,userEmail, randomPassword);
      } else {
        await signInUser(userEmail, randomPassword);
      }
    } catch (e) {
      signOutApple();
      print(e.toString());
    }
  }
  signOutApple() async {
    await FirebaseAuth.instance.signOut();
  }

  GoogleSignOut() {
    googleSignIn.signOut();
    auth.signOut();
    print("Google Log Out");
  }
  

  facebookSignOut() {
    FacebookAuth.instance.logOut();
    auth.signOut();
    print("Facebook Log Out");
  }

  signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
     

      if (result.status == LoginStatus.success) {
        final AuthCredential credential =
            FacebookAuthProvider.credential(result.accessToken!.token);

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);

        User? currentUser = FirebaseAuth.instance.currentUser;
        String userEmail = currentUser?.email ?? '';
        String userDisplayName = currentUser?.displayName ?? '';

        List<String> nameParts = userDisplayName.split(' ');
        String userFirstName = nameParts[0];
        String userLastName = nameParts.length > 1 ? nameParts[1] : '';
        print(userEmail);
        print(userFirstName);
        print(userLastName);

        String randomPassword = "toobitechsqueaks";
        print(randomPassword);

        // await userCredential.user?.updateProfile(displayName: 'Facebook User');

        isUserRegistered() {
          if (userCredential.additionalUserInfo?.isNewUser == false) {
            print("Login called");
            return signInUser(userEmail, randomPassword);
          } else {
            print("Registration called");
            return registerUser(
              userFirstName,
              userLastName,
              userEmail,
              randomPassword,
            );
          }
        }

        isUserRegistered();
      }
    } catch (e) {
      Get.back();
      showInSnackBar("Error While Authentication $e",
          color: AppColors.errorcolor);
      print(e.toString());
    }
  }

  signInUser(String email, String password) async {
    showDialogue();
    print(email);
    print(password);

    try {
      final response = await http.post(
        Uri.parse(AppUrl.signInURL),
        body: {
          "email": email,
          "password": password,
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      Get.back();
      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          print(responseData);

          appStorage.write("userToken", responseData['data']["token"]);
          appStorage.write("name", responseData['data']["name"]);
          appStorage.write("id", responseData['data']["id"]);
          appStorage.write(profile, responseData['data']["profile"]);

          print("Name ${appStorage.read("name")}");
          print("Profile: ${appStorage.read("profile")}");
          print("ID: ${appStorage.read("id")}");


          print(userToken);

          // print(appStorage.read('userToken'));
          // print("Response: ${response.body}");

          Get.offAll(const HomeScreen());
        }

      } 
      else if(responseData["success"]==false && responseData['message']== "Admin has blocked you."){
        Get.to(BlockUserScreen());

        

      }
      else {
        Get.back();
        showInSnackBar("${responseData["message"]}",
            color: AppColors.errorcolor);
        print(
            "Sign In error: ${response.statusCode.toString()} ${responseData["message"]}");
        GoogleSignOut();
        facebookSignOut();

        print("Response: ${response.body}");
      }
    } catch (error) {
       GoogleSignOut();
        facebookSignOut();
      Get.back();
      print("SignIn Error: $error");
      showInSnackBar(error.toString(), color: AppColors.errorcolor);
    }
  }
//SignUp/Registration
  registerUser(
      String firstName, String lastName, String email, String password) async {
    showDialogue();
    print(email);
   
    try {
      final response = await http.post(Uri.parse(AppUrl.registerURL), headers: {
        'Accept': 'application/json',
      }, body: {
        "name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      });
    
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          print("SignUp In successful");
          print("Response: ${response.body}");

          Get.offAll(const LoginScreen());
        }
      } else {
        print("Sign Up error: ${response.statusCode}");
        print("Response: ${response.body}");

        showInSnackBar(
            "Error ${response.statusCode} ${responseData['message']}",
            color: AppColors.errorcolor);
            GoogleSignOut();
        facebookSignOut();
        Get.back();
      }
    } catch (error) {
      GoogleSignOut();
        facebookSignOut();
      print("Error: $error");
      showInSnackBar(error.toString(), color: AppColors.errorcolor);
      Get.back();
    }
  }

  String receivedOtp = "";

  requestOTP(String email) async {
    print(email);
    showDialogue();

    try {
      final response = await http.post(Uri.parse(AppUrl.ForgotURL), body: {
        "email": email,
      });
      Get.back();
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['success'] == true) {
          print("OTP request successful");
          receivedOtp = responseData['data']['otp'].toString();
          print("Received OTP: $receivedOtp");
          sendEmail(email,receivedOtp);
          
          Get.off(() => OtpScreen(receivedOtp: receivedOtp, userEmail: email));
        }
      } else {
        print("OTP request error: ${response.statusCode}");
        print("Response: ${response.body}");
        showInSnackBar(
            "Error ${response.statusCode} ${responseData['message']}",
            color: AppColors.errorcolor);
      }
    } catch (error) {
      print("Error: $error");
    }
  }

  verifyOtpAndNavigate(List<TextEditingController> otpControllers,
      String receivedOtp, String userEmail) async {
    // if (otpControllers.any((controller) => controller.text.isEmpty)) {
    //   showInSnackBar("Please Fill all OTP Fields");
    //   return;
    // }

    String enteredOtp =
        otpControllers.map((controller) => controller.text).join();
    showDialogue();
    try {
      final response = await http.post(Uri.parse(AppUrl.OtpURL), body: {
        'otp': enteredOtp,
        'email': userEmail,
      });
      
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(enteredOtp);
      print(userEmail);

      if (response.statusCode == 200) {
        print("${response.body}");

        print('OTP verification successful');

        Get.off(() => PasswordScreen(userEmail: userEmail));
      } else {
        print("${response.body}");
        print('Failed to verify OTP: ${response.statusCode}');
        Get.back();

        showInSnackBar(
            "Error ${response.statusCode} ${responseData['message']}",
            color: AppColors.errorcolor);
      }
    } catch (error) {
      print('Error verifying OTP: $error');
    }
  }

  updatePassword(String email, String password) async {
    showDialogue();

    try {
      final response = await http.post(Uri.parse(AppUrl.passwordURL), body: {
        'email': email,
        'password': password,
      });
    
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('Password update successful');
        showInSnackBar("Password Updated Successfully",
            color: AppColors.greencolor);

        Get.offAll(() => const LoginScreen());
      } else {
        print(
            'Failed to update password: $response.statusCode ${responseData["message"]}');
        Get.back();
      }
    } catch (error) {
      print('Error updating password: $error');
      Get.back();
    }
  }
  sendEmail(String email,String mailOtp//For showing snackbar
    ) async {
  String username = 'toobitechllc@gmail.com'; //Your Email
  String password =
      'iajultdbnoggrhfe'; // 16 Digits App Password Generated From Google Account

  final smtpServer = gmail(username, password);
  // Use the SmtpServer class to configure an SMTP server:
  // final smtpServer = SmtpServer('smtp.domain.com');
  // See the named arguments of SmtpServer for further configuration
  // options.

  // Create our message.
  final message = Message()
        ..from = Address(username, 'Hide And Squeaks')
        ..recipients.add(email)
        // ..ccRecipients.addAll(['abc@gmail.com', 'xyz@gmail.com']) // For Adding Multiple Recipients
        // ..bccRecipients.add(Address('a@gmail.com')) For Binding Carbon Copy of Sent Email
        ..subject = 'Hide And Squeaks OTP'
        ..text = 'Hello, your OTP for Password reset is ${mailOtp}'
      // ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>"; // For Adding Html in email
      // ..attachments = [
      //   FileAttachment(File('image.png'))  //For Adding Attachments
      //     ..location = Location.inline
      //     ..cid = '<myimg@3.141>'
      // ]
      ;

  try {
    final sendReport = await send(message, smtpServer);
    print('Message sent: ' + sendReport.toString());
 
  } on MailerException catch (e) {
    print('Message not sent.');
    print(e.message);
    for (var p in e.problems) {
      print('Problem: ${p.code}: ${p.msg}');
    }




  }
}

deleteAccount() async {
    showDialogue();
    print("Deleting Account"); // Ensure the data is printed here
    String? currentToken = appStorage.read('userToken');

   

    try {
      final response = await http.delete(
        Uri.parse(AppUrl.deleteAccountUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $currentToken",
          "Content-Type": "application/json"
        },
       
      );

      final Map<String, dynamic> responseData = json.decode(response.body);
      print("Response Data: $responseData");

      if (responseData["status"] == true) {
        print("Account Deleted");
        print(responseData);
         showInSnackBar(responseData["message"], color: AppColors.greencolor);
        Get.to(LoginScreen());
       
      } else {
        print("Error: ${responseData['message']}");
        print(response.statusCode);
        Get.back();
        showInSnackBar(
          "Problem while deleting accout",
          color: AppColors.errorcolor,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.back();
      showInSnackBar(
        "An error occurred while deleting",
        color: AppColors.errorcolor,
      );
    }
  }


}