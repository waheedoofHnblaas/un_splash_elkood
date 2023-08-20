import 'package:un_splash/links.dart';

import '../../../../../core/class/crud.dart';

class SearchData {
  Crud crud;

  SearchData(this.crud);

  searchData(String query) async {
    var response = await crud.getSearchedData(
      '${AppLinks.searchLink}/?query=$query&&${AppLinks.clientId}',
    );
    return response.fold((l) => l, (r) => r);
  }
}
