import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/controllers/homeControllers/downloadController.dart';
import 'package:un_splash/core/class/handelingview.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DownloadController downloadController = Get.find();

    //==============    Method Widgets   ======================

    imagesButtons(String imageName) {
      return Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: IconButton(
              onPressed: () async {
                print(imageName);
                await downloadController.deleteImage(imageName);
              },
              icon: Icon(
                Icons.delete_outline_outlined,
                color: Get.theme.primaryColor,
                size: 22,
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: IconButton(
              onPressed: () async {
                print(imageName);
                await downloadController.shareFile(imageName,context);
              },
              icon: Icon(
                Icons.share,
                color: Get.theme.primaryColor,
                size: 22,
              ),
            ),
          ),
        ],
      );
    }



    //==============    Main Widget   ======================
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads Images')),
      body: GetBuilder<DownloadController>(
        builder: (controller) => HandelingView(
          statusRequest: downloadController.statusRequest!,
          widget: downloadController.images.isNotEmpty
              ? ListView.builder(
                  itemCount: downloadController.images.length,
                  itemBuilder: (context, index) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(
                          image: FileImage(
                            File(downloadController.images[index]),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: imagesButtons(downloadController.images[index]),
                      ),
                    ],
                  ),
                )
              : const Center(child: Text('No Images')),
          reLoad: () async {},
        ),
      ),
    );
  }
}
