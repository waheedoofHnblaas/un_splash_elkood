import 'package:un_splash/links.dart';

import '../../../../../core/class/crud.dart';

class HomeData {
  Crud crud;

  HomeData(this.crud);

  homeData(int page) async {
    var response = await crud.getData(
      '${AppLinks.allImagesLink}&page=$page',
    );
    return response.fold((l) => l, (r) => r);
  }
}
