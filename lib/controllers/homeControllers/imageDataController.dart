




import 'package:get/get.dart';
import 'package:un_splash/data/model/imageModel.dart';

class ImageDataController extends GetxController{

  ImageModel imageModel = ImageModel();

  void setImageModel(ImageModel image) {
    imageModel = image;
    update();
  }


}