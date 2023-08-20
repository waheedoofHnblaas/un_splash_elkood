
import 'package:get/get.dart';
import 'package:un_splash/views/screens/favoritePage.dart';
import 'package:un_splash/views/screens/homePage.dart';

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


];
