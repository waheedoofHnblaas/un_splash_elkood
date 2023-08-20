import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyServices extends GetxService {
  late SharedPreferences sharedPreferences;

  Future<MyServices> init() async {

   // await Firebase.initializeApp();
     SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
    systemNavigationBarColor:  Get.theme.backgroundColor, // navigation bar color
    statusBarColor: Colors.transparent, 
  ));
    sharedPreferences = await SharedPreferences.getInstance();
    print('==============init==============');
    return this;
  }
}


Future initServices() async {
  await Get.putAsync(() => MyServices().init());
}
