import 'dart:convert';
import 'package:get/get.dart';
import 'package:squeak/App_URL/apiurl.dart';
import 'package:squeak/Local%20Storage/global_variable.dart';
import 'package:squeak/components/colors.dart';
import 'package:http/http.dart' as http;
import 'package:squeak/models/record_model.dart';
import 'package:squeak/view/FinalAudio.dart';
import 'package:squeak/view/menu_screen.dart';
import '../components/custom_snakbar.dart';

class recordController extends GetxController {
  var isLoading = true.obs;
  RxList<RecordModel> recordings = <RecordModel>[].obs;
  postrecoding(RecordModel recordData) async {
    print(recordData.title);
    print(recordData.file);
    print(recordData.audioLength);

    String currentToken = appStorage.read('userToken');

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(AppUrl.postRecording))
            ..headers['Authorization'] = 'Bearer $currentToken'
            ..headers['Accept'] = 'application/json'
            ..fields['title'] = recordData.title!
            ..fields['audio_length'] = recordData.audioLength!
            ..files.add(await http.MultipartFile.fromPath(
              'file',
              recordData.file!,
            ));

      var response = await request.send();
      
      String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        //  Get.back();
        print("Recorded Audio Sent");
        Get.to(MenuScreen());
        
        showInSnackBar("${responseData["message"]}",
            color: AppColors.greencolor);
        isLoading.value = false;

        print(response.statusCode);
        print(responseData);

        {
          print(" ${responseData['message']}");
        }
      } else {
        print("Response: ${responseData["message"]}");
        if (responseData['success'] == false) {
          isLoading.value = false;
          // Get.back();
          print("failed to sent Audio");

          print("Response: ${responseData["message"]}");
          showInSnackBar("${responseData["message"]}",
              color: AppColors.errorcolor);
        }
      }
    } catch (error) {
      Get.back();
      print("Error: $error");
      showInSnackBar("Error: $error", color: AppColors.errorcolor);
    }
  }

  GetRecords() async {
    String currentToken = appStorage.read('userToken');
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(AppUrl.GetRecordings),
        headers: {
          'Authorization': "Bearer  $currentToken ",
          'Accept': "application/json",
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        print("Get Recrodings Called");
        var recieveRecordings = responseData['data'];
        for (var responseData in recieveRecordings) {
          print(" Title: ${responseData["title"]}");
          print("id: ${responseData["id"]}");
          print("filepath: ${responseData["file_path"]}");
          print("audio_length: ${responseData["audio_length"]}");

          recordings.insert(
              0,
              RecordModel(
                id: responseData["id"],
                title: responseData["title"],
                audioLength: responseData["audio_length"],
                file: AppUrl.imageUrl + responseData["file_path"],
              ));
        }

        isLoading.value = false;
      }
    } catch (error) {
      
      print('Error during GET request: $error');
      isLoading.value = false;
    }
  }

  deleterecordings(String recordid) async {
    print("ID:${recordid}");
    String currentToken = appStorage.read('userToken');
    try {
      final response = await http.post(
        Uri.parse(AppUrl.DeleteRecording),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken',
        },
        body: {
          'id': recordid.toString(),
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      if (response.statusCode == 200) {
        // showInSnackBar(responseData["message"], color: AppColors.greencolor);

        print(response.statusCode);
        print(responseData);
        print("Record Deleted Successfully");
      } else {
        print(response.statusCode);
        showInSnackBar(responseData["message"], color: AppColors.errorcolor);
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }
}
