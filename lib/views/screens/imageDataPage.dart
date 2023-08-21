import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/controllers/homeControllers/favoriteController.dart';
import 'package:un_splash/controllers/homeControllers/imageDataController.dart';
import 'package:un_splash/data/model/imageModel.dart';

import '../../controllers/homeControllers/downloadController.dart';

class ImageDataPage extends StatelessWidget {
  const ImageDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageDataController imageDataController = Get.find();
    FavoriteController favoriteController = Get.find();
    DownloadController downloadController = Get.find();


    //==============    Method Widgets    ======================

    showDownloadDialog() {
      Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(18),
              ),
              color: Get.theme.scaffoldBackgroundColor),
          height: Get.height / 4,
          width: Get.width,
          child: Column(
            children: [
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Choose Download Size',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await downloadController.downloadImage(
                        imageDataController.imageModel, 'full');
                  },
                  child: const Text('Full Quality'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await downloadController.downloadImage(
                        imageDataController.imageModel, 'mid');
                  },
                  child: const Text('Mid Quality'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await downloadController.downloadImage(
                        imageDataController.imageModel, 'low');
                  },
                  child: const Text('Low Quality'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    actionButtons() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GetBuilder<DownloadController>(
            builder: (downloadController) => downloadController
                    .downloadingIds.keys
                    .contains(imageDataController.imageModel.id)
                ? Stack(
                    children: [
                      CircularProgressIndicator(
                        color: Colors.green,
                        backgroundColor: Get.theme.scaffoldBackgroundColor,
                        strokeWidth: 2,
                        value: double.parse(
                              downloadController.downloadingIds.values.first
                                  .toString(),
                            ) /
                            100,
                      ),
                      Positioned(
                        left: 5,
                        top: 5,
                        child: Text(
                          '${downloadController.downloadingIds.values.first}%',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ),
                    ],
                  )
                : IconButton(
                    onPressed: () async {
                      showDownloadDialog();
                    },
                    icon: Icon(
                      Icons.download_outlined,
                      color: Get.theme.primaryColor,
                    ),
                  ),
          ),
          IconButton(
            onPressed: () async {
              await favoriteController
                  .setFavorite(imageDataController.imageModel);
            },
            icon: GetBuilder<FavoriteController>(
              builder: (controller) {
                return Icon(
                  favoriteController
                          .isContain(imageDataController.imageModel.id!)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favoriteController
                          .isContain(imageDataController.imageModel.id!)
                      ? Colors.red
                      : Get.theme.primaryColor,
                );
              },
            ),
          ),
          Row(
            children: [
              Text(
                imageDataController.imageModel.likes.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 3,
              ),
              Icon(CupertinoIcons.hand_thumbsup, color: Get.theme.primaryColor),
            ],
          ),
        ],
      );
    }

    descWidget() {
      return Container(
        child: imageDataController.imageModel.description.isNull
            ? Container()
            : Container(
                width: Get.width - 50,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12),
                  ),
                  color: Get.theme.primaryColor.withOpacity(0.1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(imageDataController.imageModel.description!),
                ),
              ),
      );
    }

    imageWidget() {
      return Center(
        child: Stack(
          children: [
            //==============    Blur Widget    ======================
            Center(
                child: CachedNetworkImage(
              imageUrl: imageDataController.imageModel.urls!.small!,
              imageBuilder: (context, imageProvider) => Container(
                height: Get.height / 2,
                width: Get.width / 1.1,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(18),
                  ),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )),
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 33.0,
                    sigmaY: 33.0,
                    tileMode: TileMode.clamp,
                  ),
                  child: Container(
                    height: Get.height / 2,
                    width: Get.width / 1.1,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ),
                ),
              ),
            ),

            //==============    Image Widget    ======================

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: Get.height / 2,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
                color: Get.theme.primaryColor.withOpacity(0.08),
              ),
            ),
            Center(
              child: CachedNetworkImage(
                imageUrl: imageDataController.imageModel.urls!.small!,
                imageBuilder: (context, imageProvider) => Container(
                  height: Get.height / 2,
                  width: Get.width / 1.2,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(18),
                    ),
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    //==============    Main Widget    ======================
    return Scaffold(
      appBar: AppBar(title: const Text('Image Info')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              imageWidget(),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          actionButtons(),
          const SizedBox(
            height: 20,
          ),
          descWidget(),
        ],
      ),
    );
  }
}
