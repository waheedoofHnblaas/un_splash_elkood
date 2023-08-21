import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/controllers/homeControllers/favoriteController.dart';

import '../widget/imageCard.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FavoriteController favoriteController = Get.find();


    //==============    Method Widgets   ======================
    gridViewWidget() {
      return favoriteController.imagesList.isNotEmpty? Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child:  GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: Get.height / 3,
            crossAxisSpacing: 5.0, // Spacing between columns
            mainAxisSpacing: 10.0, // Spacing between rows
          ),
          itemCount: favoriteController.imagesList.length,
          itemBuilder: (BuildContext context, int index) {
            return ImageCard(
              index: index,
              list: favoriteController.imagesList,
            );
          },
        ),
      ):const Text('No Images');
    }

    //==============    Main Widget   ======================
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Images')),
      body: Center(
        child: GetBuilder<FavoriteController>(
          builder: (controller) => gridViewWidget(),
        ),
      ),
    );
  }
}
