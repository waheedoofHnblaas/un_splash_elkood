import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/controllers/homeControllers/downloadController.dart';
import 'package:un_splash/controllers/homeControllers/favoriteController.dart';
import 'package:un_splash/controllers/homeControllers/imageDataController.dart';
import 'package:un_splash/core/constant/approutes.dart';
import 'package:un_splash/core/function/checkinternet.dart';
import 'package:un_splash/data/datasource/remote/home/home/searshData.dart';
import '../../core/class/statusrequest.dart';
import '../../core/function/handlingdata.dart';
import '../../data/datasource/remote/home/home/homeData.dart';
import '../../data/model/imageModel.dart';

class HomeController extends GetxController {
  StatusRequest? statusRequest = StatusRequest.none;
  StatusRequest? statusRequest2 = StatusRequest.none;
  final HomeData homeData = HomeData(Get.find());
  final SearchData searchData = SearchData(Get.find());
  List<ImageModel> imagesList = [];
  List<ImageModel> searchedImagesList = [];
  ScrollController scrollController = ScrollController();
  int pageIndex = 0;
  int searchPageIndex = 0;
  TextEditingController textControllerSearch = TextEditingController();

  @override
  Future<void> onInit() async {
    scrollController.addListener(() async {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        print(scrollController.offset);
        if (isSearchMode) {
          await getSearchedImages(textControllerSearch.text, searchPageIndex);
        } else {
          await getImages(pageIndex);
        }
      }
    });
    await getImages(pageIndex);
    super.onInit();
  }

  Future getImages(page) async {
    print('==========getImages==========');
    // imagesList.clear();
    if (page == 0) {
      pageIndex = 0;
      imagesList.clear();
      statusRequest = StatusRequest.loading;
      update();
    } else {
      statusRequest2 = StatusRequest.loading;
      update();
    }

    if (await checkInternet()) {
      var response = await homeData.homeData(page);
      statusRequest = handlingData(response);
      print('==========$statusRequest==========');
      if (statusRequest == StatusRequest.success) {
        if (response.isNotEmpty) {
          List images = response;
          for (var element in images) {
            imagesList.add(ImageModel.fromJson(element));
          }
          pageIndex++;
          statusRequest = StatusRequest.success;
          statusRequest2 = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.success;
          statusRequest2 = StatusRequest.success;
        }
      } else {
        if (pageIndex == 0) {
          statusRequest = StatusRequest.failure;
        } else {
          statusRequest2 = StatusRequest.failure;
        }
      }
    } else {
      if (pageIndex == 0) {
        statusRequest = StatusRequest.offline;
      } else {
        statusRequest2 = StatusRequest.offline;
      }
    }

    update();
  }

  int searchCount = 0;

  Future getSearchedImages(String textSearch, int page) async {
    print('==========getSearchedImages==========');
    if (page == 0) {
      searchPageIndex = 0;
      searchedImagesList.clear();
      searchCount = 0;
      statusRequest = StatusRequest.loading;
      update();
    } else {
      statusRequest2 = StatusRequest.loading;
      update();
    }
    if (await checkInternet()) {
      var response = await searchData.searchData(textSearch);
      statusRequest = handlingData(response);
      print('==========$statusRequest==========');
      if (statusRequest == StatusRequest.success) {
        if (response['results'].isNotEmpty) {
          List images = response['results'];
          searchCount = response['total'];
          // searchPages = response['total_pages'];
          if (searchCount >= searchedImagesList.length) {
            for (var element in images) {
              searchedImagesList.add(ImageModel.fromJson(element));
            }
            searchPageIndex++;
          }

          statusRequest = StatusRequest.success;
          statusRequest2 = StatusRequest.success;
        } else {
          statusRequest = StatusRequest.success;
          statusRequest2 = StatusRequest.success;
        }
      } else {
        if (searchPageIndex == 0) {
          statusRequest = StatusRequest.failure;
        } else {
          statusRequest2 = StatusRequest.failure;
        }
      }
    } else {
      if (searchPageIndex == 0) {
        statusRequest = StatusRequest.offline;
      } else {
        statusRequest2 = StatusRequest.offline;
      }
    }

    update();
  }

  ref() async {
    pageIndex = 0;
    await getImages(pageIndex);
  }

  bool isSearchMode = false;

  void changeSearchMode() {
    if (isSearchMode) {
      if (textControllerSearch.text.isNotEmpty) {
        textControllerSearch.clear();
      } else {
        isSearchMode = false;
      }
    } else {
      isSearchMode = true;
      searchPageIndex = 0;
    }

    update();
  }

  void change() {
    searchedImagesList.clear();
    searchPageIndex = 0;
    searchCount = 0;
    update();
  }

  Future<void> toFavoritePage() async {
    FavoriteController favoriteController = Get.find();
    await favoriteController.getFavorites();
    Get.toNamed(AppRoute.favorite);
  }

  Future<void> toDownloadPage() async {
    DownloadController downloadController = Get.find();
    await downloadController.getDownloadedImages();
    Get.toNamed(AppRoute.download);
  }

  void toImageDataPage(ImageModel imageModel) {
    ImageDataController imageDataController = Get.find();
    imageDataController.setImageModel(imageModel);
    Get.toNamed(AppRoute.data);
  }
}
