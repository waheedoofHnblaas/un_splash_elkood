import 'dart:convert';

import 'package:get/get.dart';
import 'package:un_splash/core/services/services.dart';
import 'package:un_splash/data/model/imageModel.dart';

class FavoriteController extends GetxController {
  MyServices myServices = Get.find();
  List<ImageModel> imagesList = [];

  @override
  void onInit() async {
    await getFavorites();
    super.onInit();
  }

  getFavorites() async {
    try {
      imagesList.clear();
      for (String mapImage in myServices.sharedPreferences.getKeys()) {
        imagesList.add(
          ImageModel.fromJson(
            await jsonDecode(myServices.sharedPreferences.getString(mapImage)!),
          ),
        );
      }
      update();
    } catch (e) {
      print(e);
      print('getFavorites');
    }
  }

  setFavorite(ImageModel imageModel) async {
    if (myServices.sharedPreferences.containsKey(imageModel.id!)) {
      await myServices.sharedPreferences.remove(
        imageModel.id!,
      );
    } else {
      await myServices.sharedPreferences.setString(
        imageModel.id!,
        jsonEncode(imageModel).toString(),
      );
    }
    await getFavorites();
    update();
  }

  isContain(String s) {
    if(myServices.sharedPreferences.containsKey(s)){
      return true;
    }else{
      return false;
    }
  }
}
