import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
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
              icon: GetBuilder<FavoriteController>(builder: (controller) {
                return Icon(
                  favoriteController.isContain(list[index].id!) ?
                   Icons.favorite
                  : Icons.favorite_border,
                  size: 15,
                  color: Get.theme.primaryColor,
                );
              }),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
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
              onPressed: () {
                // homeController.downloadImage(list[index]);
              },
              icon: Icon(
                Icons.add,
                size: 15,
                color: Get.theme.primaryColor,
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
        placeholder: (context, url) =>
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: Get.height / 7,
                horizontal: Get.width / 5,
              ),
              child: CircularProgressIndicator(color: Get.theme.primaryColor),
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
