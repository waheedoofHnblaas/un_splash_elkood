import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/class/statusrequest.dart';
import '../../data/model/imageModel.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DownloadController extends GetxController {
  Map<String, int> downloadingIds = {};
  List<String> images = [];

  @override
  void onInit() async {
    await getDownloadedImages();
    super.onInit();
  }

  info() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    print('Running on ${androidInfo.model}'); // e.g. "Moto G (4)"
    print('CPU architecture: ${androidInfo.supportedAbis}');

    // IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    // print('Running on ${iosInfo.utsname.machine}');  // e.g. "iPod7,1"
    //
    // WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    // print('Running on ${webBrowserInfo.userAgent}');  // e.g. "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:61.0) Gecko/20100101 Firefox/61.0"
  }

  StatusRequest? statusRequest = StatusRequest.none;

  getDownloadedImages() async {
    statusRequest = StatusRequest.loading;
    update();
    images.clear();
    Directory? externalDir = await getExternalStorageDirectory();
    String imagePath = externalDir!.path;
    List<FileSystemEntity> files = Directory(imagePath).listSync();
    images = files.map((file) {
      return file.path;
    }).toList();
    statusRequest = StatusRequest.success;
    update();
  }

  downloadImage(ImageModel imageModel, String quality) async {
    if (Get.isBottomSheetOpen == true) {
      Get.back();
    }
    Dio dio = Dio();
    Directory? galleryDir = await getExternalStorageDirectory();
    if (!downloadingIds.containsKey(imageModel.id!)) {
      if (downloadingIds.isNotEmpty) {
      } else {
        var response = await dio.get(
          quality == 'full'
              ? imageModel.urls!.full!
              : quality == 'mid'
                  ? imageModel.urls!.regular!
                  : imageModel.urls!.small!,
          options: Options(responseType: ResponseType.bytes),
          onReceiveProgress: (count, total) {
            String avg = (count / total * 100).toStringAsFixed(0);
            // print("${imageModel.id!} : $avg%");
            downloadingIds.assign(imageModel.id!, int.parse(avg));
            update();
            print('=========map================');
            print(downloadingIds);
          },
        );

        File file = File('${galleryDir!.path}/${imageModel.id!}.jpg');
        await file.writeAsBytes(response.data);
        print('Image saved successfully');
        print('${galleryDir.path}/${imageModel.id!}.jpg');

        // final result = await ImageGallerySaver.saveImage(
        //   Uint8List.fromList(response.data),
        //   quality: 5,
        //   name: imageModel.id!,
        // );
        downloadingIds.clear();
      }
    }
    downloadingIds.clear();
    await getDownloadedImages();
    print(galleryDir);
  }

  deleteImage(String fileName) async {
    // Directory? dir = await getExternalStorageDirectory();
    final targetFile = Directory(fileName);
    // if (targetFile.existsSync()) {
    targetFile.deleteSync(recursive: true);
    // }
    images.remove(fileName);
    update();
  }

  shareFile(String fileName, context) async {
    // _onShare method:
    Share.shareXFiles(
      [XFile(fileName)],
      text: 'https://unsplash.com',
    );
  }
}
