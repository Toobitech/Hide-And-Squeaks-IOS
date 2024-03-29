import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/components/colors.dart';
import 'package:squeak/models/user_model.dart';
import 'package:squeak/global/alertbox.dart';
import 'package:squeak/view/homescreen.dart';

import '../components/custom_snakbar.dart';

class ProfileController extends GetxController {
  final Rx<File?> image = Rx<File?>(null);

  var isLoading = false.obs;

  void pickImage() async {
    try {
      final pickedImage =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedImage == null) {
        print('No image picked.');
        return;
      }

      final imageTemp = File(pickedImage.path);

      image.value = imageTemp;
      print(image.value);
    } catch (e) {
      print('Failed to pick image: $e');
    }
  }

  postProfile(userModel model) async {
    showDialogue();
    String currentToken = appStorage.read('userToken');

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(AppUrl.postProfileURL))
            ..headers['Authorization'] = 'Bearer $currentToken'
            ..headers['Accept'] = 'application/json'
            ..fields['pet_name'] = model.petName!
            ..fields['pet_breed'] = model.petBreed!;
      List<http.MultipartFile> files = [];

      if (model.profile != null) {
        files.add(await http.MultipartFile.fromPath(
          'profile',
          model.profile!,
        ));
      }
      request.files.addAll(files);

      var response = await request.send();
      final Map<String, dynamic> responseData =
          json.decode(await response.stream.bytesToString());

      if (response.statusCode == 200) {
        Get.back();

        showInSnackBar("${responseData["message"]}",
            color: AppColors.greencolor);

        if (responseData['success'] == true) {
          print(responseData);

          print("Response: $responseData");
          Get.to(HomeScreen());
        } else {
          print(" ${responseData['message']}");
        }
      } else {
        print("Response: ${responseData["message"]}");
        if (responseData['success'] == false) {
          print("Response: ${responseData["message"]}");
          showInSnackBar("${responseData["message"]}",
              color: AppColors.errorcolor);
        } else {
          showInSnackBar("${responseData["message"]}",
              color: AppColors.errorcolor);
        }
      }
    } catch (error) {
      showInSnackBar("Error: $error", color: AppColors.errorcolor);
      Get.back();

      print("Error: $error");
    }
  }

  Rx<userModel> userDataList = userModel().obs;

  getUserProfile() async {
    String currentToken = appStorage.read('userToken');

    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse(AppUrl.GetProfileURL),
        headers: {
          'Authorization': "Bearer  $currentToken ",
          'Accept': "application/json"
        },
      );
      print('Get user profile Status');
      print(response.statusCode);
      print('Response Body');
      print(response.body);
      log(response.body);
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        appStorage.write(name, responseData['data']["name"]);
        // appStorage.write("name", responseData['data']["name"]);
        // appStorage.write(profile, responseData['data']["profile"]);
        appStorage.write(id, responseData['data']["id"]);
        print(appStorage.read("name"));
        print(appStorage.read("id"));
        print(appStorage.read("profile"));

        Map<String, dynamic> userData = responseData['data'];

        userModel datauser = userModel.fromJson(userData);
        userDataList.value = datauser;
        print(
            "UserData: ${datauser.petName}, ${datauser.petBreed},${datauser.profile}");

        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print(e.toString());
      print('discover error');
    }
  }
}
