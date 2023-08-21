import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/controllers/homeControllers/homeController.dart';
import 'package:un_splash/core/class/handelingview.dart';
import 'package:un_splash/core/class/statusrequest.dart';
import 'package:un_splash/views/widget/apptextfield.dart';
import 'package:un_splash/views/widget/imageCard.dart';

import '../../controllers/homeControllers/downloadController.dart';
import '../../controllers/homeControllers/favoriteController.dart';
import '../../controllers/homeControllers/imageDataController.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    Get.put(FavoriteController());
    Get.put(DownloadController());
    Get.put(ImageDataController());

    //==============    Method Widgets    ======================

    gridViewWidget() {
      return homeController.isSearchMode &&
              homeController.searchedImagesList.isEmpty
          ? const Center(child: Text('No Images'))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              child: GridView.builder(
                controller: homeController.scrollController,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: Get.height / 3,
                  crossAxisSpacing: 3.0, // Spacing between columns
                  mainAxisSpacing: 3.0, // Spacing between rows
                ),
                itemCount: homeController.isSearchMode
                    ? homeController.searchedImagesList.length
                    : homeController.imagesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ImageCard(
                    index: index,
                    list: homeController.isSearchMode
                        ? homeController.searchedImagesList
                        : homeController.imagesList,
                  );
                },
              ),
            );
    }

    lazyLoadingWidget() {
      return SizedBox(
        child: homeController.statusRequest2 == StatusRequest.loading
            ? Container(
                decoration: BoxDecoration(
                  color: Get.theme.scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    backgroundColor: Get.theme.scaffoldBackgroundColor,
                    color: Get.theme.primaryColor,
                  ),
                ),
              )
            : homeController.statusRequest2 == StatusRequest.success
                ? Container()
                : const Text('No Connection Try Again'),
      );
    }

    searchWidget() {
      return AnimatedContainer(
        color: Colors.transparent,
        duration: const Duration(seconds: 1),
        child: homeController.isSearchMode
            ? AppTextField(
                type: 'Search',
                iconData: Icons.search,
                onTap: () async {
                  await homeController.getSearchedImages(
                    homeController.textControllerSearch.text,
                    homeController.searchPageIndex,
                  );
                },
                inputType: TextInputType.text,
                submit: (v) async {
                  await homeController.getSearchedImages(
                    homeController.textControllerSearch.text,
                    homeController.searchPageIndex,
                  );
                },
                onChanged: (p0) {
                  homeController.change();
                },
                validator: (p0) {},
                textFieldController: homeController.textControllerSearch,
              )
            : Container(),
      );
    }

    searchActions() {
      return GetBuilder<HomeController>(
        builder: (controller) {
          return Row(
            children: [
              homeController.isSearchMode
                  ? Text(homeController.searchCount.toString())
                  : Container(),
              IconButton(
                onPressed: () {
                  homeController.changeSearchMode();
                },
                icon: Icon(
                  homeController.isSearchMode ? Icons.close : Icons.search,
                  color: Get.theme.primaryColor,
                ),
              ),
            ],
          );
        },
      );
    }


    titleWidget(){
      return Row(
        children: [
          IconButton(
            onPressed: () {
              homeController.toDownloadPage();
            },
            icon: Icon(
              Icons.download,
              color: Get.theme.primaryColor,
            ),
          ),
          IconButton(
            onPressed: () {
              homeController.toFavoritePage();
            },
            icon: Icon(
              Icons.favorite_border,
              color: Get.theme.primaryColor,
            ),
          ),
          Expanded(child: Container()),
          const Text('UnSplash'),
          Expanded(flex: 2, child: Container()),
        ],
      );
    }

    //==============    Main Widget   ======================
    return Scaffold(
      appBar: AppBar(
        title: titleWidget(),
        actions: [searchActions()],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await homeController.getImages(0);
        },
        child: GetBuilder<HomeController>(
          builder: (controller) {
            return Column(
              children: [
                searchWidget(),
                Expanded(
                  child: HandelingView(
                    reLoad: () async {
                      await homeController.ref();
                    },
                    statusRequest: homeController.statusRequest!,
                    widget: Column(
                      children: [
                        Expanded(
                          child: gridViewWidget(),
                        ),
                        lazyLoadingWidget()
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
