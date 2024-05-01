import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:squeak/components/colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:squeak/models/comment_model.dart';
import 'package:squeak/models/video_model.dart';
import 'package:squeak/view/socialfeed.dart';
import 'package:squeak/view/video_player.dart';
import 'package:video_compressor/video_compressor.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../App_URL/apiurl.dart';
import '../Local Storage/global_variable.dart';
import '../components/custom_snakbar.dart';
import '../global/alertbox.dart';

class VideoController extends GetxController {
  var isLoading = false.obs;
  var viewDataLaoding = false.obs;

  Rx<File?> videofile = Rx<File?>(null);
  Rx<File?> thumbnailFile = Rx<File?>(null);

  pickVideo() async {
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (pickedFile != null) {
      videofile.value = File(pickedFile.path);
      generateThumbnail();
      await compressVideo(videofile.value!); 
      
    }
  }
  

  generateThumbnail() async {
    if (videofile.value != null) {
      final thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: videofile.value!.path,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
      );

      thumbnailFile.value = File(thumbnailPath!);
    }
  }
  compressVideo(File videoFile) async {
  final thumbnailPath = (await getTemporaryDirectory()).path;
  final compressedVideoPath = '$thumbnailPath/compressed.mp4';
  final thumbnailInfo = await VideoCompressor.compressVideo(
    videofile as String,
    quality: VideoQuality.LowResQuality,
    deleteOrigin: false,
  );

  if (thumbnailInfo != null) {
    videofile.value = File(compressedVideoPath); // Update videofile with compressed video
    // Generate thumbnail for compressed video
  }
}

  RxBool uploading = false.obs;

  postVideo(VideoModel videodata) async {
  
    print(videodata.title);
    print(videodata.description);
    print(videodata.videotype);
    print(videodata.file_path);
    print(videodata.thumbnail);

    showDialogue();

    String currentToken = appStorage.read('userToken');

    try {
      var request =
          http.MultipartRequest('POST', Uri.parse(AppUrl.PostVideoURL))
            ..headers['Authorization'] = 'Bearer $currentToken'
            ..headers['Accept'] = 'application/json'
            ..fields['title'] = videodata.title!
            ..fields['description'] = videodata.description!
            ..fields['video_type'] = videodata.videotype!
            ..files.add(await http.MultipartFile.fromPath(
              'file_path',
              videodata.file_path!,
            ))
            ..files.add(await http.MultipartFile.fromPath(
              'thumbnail_path',
              videodata.thumbnail!,
            ));

      var response = await request.send();
      String responseBody = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(responseBody);

      if (response.statusCode == 200) {
        showInSnackBar("${responseData["message"]}",
            color: AppColors.greencolor);

        print(response.statusCode);
        print(responseData);
        if (videofile.value != null) {
          videofile.value == null;
        }
        if (thumbnailFile.value != null) {
          thumbnailFile.value = null;
        }
        

        {
          print(" ${responseData['message']}");
          Get.off(SocialScreen());
        }
      } else {
        print("Response: ${responseData["message"]}");
        if (responseData['success'] == false) {
          Get.back();

          print("Response: ${responseData["message"]}");
          showInSnackBar("${responseData["message"]}",
              color: AppColors.errorcolor);
        }
      }
    } catch (error) {
      Get.back();
      print("Error: $error");
    }
  }

  List<VideoModel> videoListprivate = <VideoModel>[].obs;
  List<VideoModel> videoListpublic = <VideoModel>[].obs;

  Getvideo() async {
    String currentToken = appStorage.read('userToken');
    isLoading.value = true;

    try {
      final response = await http.get(
        Uri.parse(AppUrl.GetVideoURL),
        headers: {
          'Authorization': "Bearer  $currentToken ",
          'Accept': "application/json",
        },
      );
      if (response.statusCode == 200) {
        print(response.body);
        print("API call");
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == true) {
          if (responseData['data'] != null &&
              responseData['data'].containsKey('public')) {
            var publicVideos = responseData['data']['public'] as List;

            final List<dynamic> videoDataList = publicVideos;

            for (var videoData in videoDataList) {
              // print("videoid: ${videoData["id"]}");
              // print(videoData["title"]);
              // print(videoData["user_id"]);
              // print(videoData["file_path"]);
              // print(videoData["thumbnail_path"]);
              // print(videoData["likes_count"]);
              // print(videoData["created_at]"]);
              // print(videoData["comments_count"]);

              videoListpublic.insert(
                  0,
                  VideoModel(
                    title: videoData["title"],
                    description: videoData["description"],
                    file_path: videoData["filepath"],
                    thumbnail: videoData["thumbnail_path"],
                    created_at: videoData["created_at"],
                    id: videoData["id"],
                    totalLikes: videoData["likes_count"],
                    totalComments: videoData["comments_count"],
                  ));
                  // videoListprivate.reversed.toList();
            }
            // print(videoListpublic.length);
          }
          if (responseData['data'] != null &&
              responseData['data'].containsKey('private')) {
            var privateVideos = responseData['data']['private'] as List;

            final List<dynamic> videoDataList = privateVideos;

            for (var videoData in videoDataList) {
              // print(videoData["id"]);
              // print(videoData["title"]);
              // print(videoData["user_id"]);
              // print(videoData["file_path"]);
              // print(videoData["thumbnail_path"]);
              // print(videoData["likes_count"]);
              // print(videoData["created_at]"]);
              // print(videoData["comments_count"]);

              videoListprivate.insert(
                  0,
                  VideoModel(
                    title: videoData["title"],
                    description: videoData["description"],
                    file_path: videoData["file_path"],
                    thumbnail: videoData["thumbnail_path"],
                    created_at: videoData["created_at"],
                    id: videoData["id"],
                    totalLikes: videoData["likes_count"],
                    totalComments: videoData["comments_count"],
                  ));
            }
            // print(videoListprivate.length);
          }
          isLoading.value = false;
        }
      }
    } catch (error) {
      print('Error during GET request: $error');
      isLoading.value = false;
    }
  }

  Addview(int userid) async {
    String currentToken = appStorage.read('userToken');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.addViewUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken',
        },
        body: {
          'video_id': userid.toString(),
        },
      );
      final dynamic responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print(responseData["message"]);
        print("View Added Successfuly");
      } else {
        print('Failed To Post View: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error during POST request: $error');
    }
  }

  ViewData(userid) async {
    viewDataLaoding.value = true;
    print(userid);
    print("View data API call");
    String currentToken = appStorage.read('userToken');

    try {
      final response = await http.post(
        Uri.parse(AppUrl.viewVideoURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken ',
        },
        body: {
          'video_id': userid.toString(),
        },
      );
      final Map<String,dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print("data:$responseData");
        
        String profileImagePath = responseData['data']['video']['user']['profile'];
        String user_name=responseData['data']['video']['user']['name'];
        print(user_name);
        
        print(profileImagePath);
        // print("user_profile: ${responseData["data"]["video"]["user"]["profile"]}");

        // print("user_id: ${responseData["data"]["video"]["user_id"]}");
        // print("id: ${responseData["data"]["video"]["id"]}");
        // print("created_at: ${responseData["data"]["video"]["created_at"]}");
        // print("Totalviews: ${responseData["data"]["total_views"]}");
        // print("TotalLikes: ${responseData["data"]["total_likes"]}");
        // print("isUserLikedVideo: ${responseData["data"]["userLikedVideo"]}");
        // print("TotalComments: ${responseData["data"]["total_comments"]}");
        // print(
        //     "thumbpath: ${AppUrl.imageUrl + responseData["data"]["video"]["thumbnail_path"]}");
        // print(
        //     "Filepath: ${AppUrl.videoURL + responseData["data"]["video"]["file_path"]}");
        List<Comment> comments =
            (responseData['data']['video']['comments'] as List)
                .map((commentJson) => Comment.fromJson(commentJson))
                .toList().reversed.toList() ;

        var videoViewData = VideoModel(
            id: responseData["data"]["video"]["id"],
            thumbnail: responseData["data"]["video"]["thumbnail_path"],
            user_id: responseData["data"]["video"]["user_id"],
            title: responseData["data"]["video"]["title"],
            created_at: responseData["data"]["video"]["created_at"],
            file_path:
                AppUrl.videoURL + responseData["data"]["video"]["file_path"],
            totalLikes: responseData["data"]["total_likes"],
            totalComments: responseData["data"]["total_comments"],
            totalViews: responseData["data"]["total_views"],
            userLikedVideo: responseData["data"]["userLikedVideo"],
            user_profile: AppUrl.imageUrl+profileImagePath.toString(),
            user_name: user_name
           
            );
        Get.to(VideoPlayerScreen(view: videoViewData, comments: comments));
        viewDataLaoding.value = false;
      } else {
        print('POST request failed with status: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error during POST request: $error');
    }
  }

  postComment(String comment, int videoId) async {
    String currentToken = appStorage.read('userToken');
    try {
      final response = await http.post(
        Uri.parse(AppUrl.commentUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken ',
        },
        body: {
          'comment': comment,
          'video_id': videoId.toString(),
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // showInSnackBar(responseData["message"], color: AppColors.greencolor);
        print('Comment posted successfully');
        print('Response body: ${[responseData["message"]]}');
      } else {
        print('Error posting comment:${response.statusCode}');
        print('Error response body: ${responseData["message"]}');
      }
    } catch (e) {
      print('Exception during postComment: $e');
    }
  }


  postLike(videoId) async {
    String currentToken = appStorage.read('userToken');
    try {
      final response = await http.post(
        Uri.parse(AppUrl.likeUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken ',
        },
        body: {
          'video_id': videoId.toString(),
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        print('Like posted successfully');
        print(responseData["message"]);

        print('Response body: ${response.body}');
      } else {
        print('Error posting Like. Status code: ${response.statusCode}');
        print('Error response body: ${response.body}');
      }
    } catch (e) {
      print('Exception during postLike: $e');
    }
  }

  deleteVideo(int videoId) async {
    print(videoId);
    String currentToken = appStorage.read('userToken');
    try {
      final response = await http.post(
        Uri.parse(AppUrl.videoDelUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer  $currentToken',
        },
        body: {
          'video_id': videoId.toString(),
        },
      );
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
       print(response.statusCode);

      if (response.statusCode == 200) {
        showInSnackBar(responseData["message"], color: AppColors.greencolor);

        print(response.statusCode);
       
        print("Video Deleted Successfully");
        // Getvideo();
      } else {
        print(response.statusCode);
        showInSnackBar(responseData["message"], color: AppColors.errorcolor);
      }
    } catch (error) {
      print('Error deleting data: $error');
    }
  }
}
