
import 'package:get/get.dart';
import 'package:un_splash/views/screens/downloadPage.dart';
import 'package:un_splash/views/screens/favoritePage.dart';
import 'package:un_splash/views/screens/homePage.dart';
import 'package:un_splash/views/screens/imageDataPage.dart';

import 'core/constant/approutes.dart';


List<GetPage<dynamic>>? routes = [
  GetPage(
    name: AppRoute.home,
    page: () =>  const HomePage(),
  ),
  GetPage(
    name: AppRoute.favorite,
    page: () =>  const FavoritePage(),
  ),
  GetPage(
    name: AppRoute.download,
    page: () =>  const DownloadPage(),
  ),
  GetPage(
    name: AppRoute.data,
    page: () =>  const ImageDataPage(),
  ),


];
