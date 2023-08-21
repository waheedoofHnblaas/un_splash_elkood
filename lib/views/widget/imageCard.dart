import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:un_splash/controllers/homeControllers/downloadController.dart';
import 'package:un_splash/controllers/homeControllers/favoriteController.dart';
import 'package:un_splash/controllers/homeControllers/homeController.dart';
import 'package:un_splash/data/model/imageModel.dart';

class ImageCard extends StatelessWidget {
  const ImageCard({Key? key, required this.index, required this.list})
      : super(key: key);

  final int index;
  final List<ImageModel> list;

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find();
    FavoriteController favoriteController = Get.find();
    getSubDesc(String description) {
      int l = 20;
      if (description.length > l) {
        return description.replaceRange(l, description.length, '...');
      } else {
        return description;
      }
    }

    descWidget() {
      return list[index].description.isNull
          ? Container()
          : Container(
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withOpacity(0.8),
              ),
              width: Get.width / 2,
              padding: const EdgeInsets.only(left: 10, bottom: 5, top: 5),
              child: Text(
                getSubDesc(
                  list[index].description!,
                ),
                style: TextStyle(
                  color: Get.theme.scaffoldBackgroundColor,
                ),
              ),
            );
    }

    showDownloadDialog() {
      DownloadController downloadController = Get.find();

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
                    await downloadController.downloadImage(list[index], 'full');
                  },
                  child: const Text('Full Quality'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await downloadController.downloadImage(list[index], 'mid');
                  },
                  child: const Text('Mid Quality'),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () async {
                    await downloadController.downloadImage(list[index], 'low');
                  },
                  child: const Text('Low Quality'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    imagesButtons() {
      return Row(
        children: [
          Container(
            width: 33,
            height: 33,
            decoration: BoxDecoration(
              color: Get.theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: IconButton(
              onPressed: () async {
                await favoriteController.setFavorite(list[index]);
              },
              icon: GetBuilder<FavoriteController>(
                builder: (controller) {
                  return Icon(
                    favoriteController.isContain(list[index].id!)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    size: 15,
                    color: favoriteController.isContain(list[index].id!)
                        ? Colors.red
                        : Get.theme.primaryColor,
                  );
                },
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          GetBuilder<DownloadController>(
            builder: (downloadController) =>
                downloadController.downloadingIds.keys.contains(list[index].id)
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
                    : Container(
                        width: 33,
                        height: 33,
                        decoration: BoxDecoration(
                          color: Get.theme.scaffoldBackgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        child: IconButton(
                          onPressed: () async {
                            showDownloadDialog();
                          },
                          icon: Icon(
                            Icons.download,
                            size: 15,
                            color: Get.theme.primaryColor,
                          ),
                        ),
                      ),
          ),
        ],
      );
    }

    imageWidget() {
      return CachedNetworkImage(
        imageUrl: list[index].urls!.small!,
        fit: BoxFit.cover,
        height: Get.height / 3,
        width: Get.width / 2,
        placeholder: (context, url) => Center(
          child: SizedBox(
            width: 20,
            height: 3,
            child: LinearProgressIndicator(
              color: Get.theme.primaryColor.withOpacity(0.8),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      child: Stack(
        children: [
          Container(child: imageWidget()),
          SizedBox(child: descWidget()),
          Positioned(bottom: 8, right: 8, child: imagesButtons()),
        ],
      ),
    );
  }
}
