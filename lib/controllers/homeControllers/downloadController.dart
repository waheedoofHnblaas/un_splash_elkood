import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/class/statusrequest.dart';
import '../../data/model/imageModel.dart';

class DownloadController extends GetxController {
  Map<String, int> downloadingIds = {};
  List<String> images = [];

  @override
  void onInit() async {
    await getDownloadedImages();
    super.onInit();
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

  bool done = false;

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

        if (downloadingIds.values.first == 100) {
          Timer timer = Timer.periodic(const Duration(seconds: 1), (timer) {
            done = !done;
            update();
          });
          Timer(const Duration(seconds: 5), () {
            timer.cancel();
            done = false;
            update();
          });
        }
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
