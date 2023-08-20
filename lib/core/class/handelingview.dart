import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/core/class/statusrequest.dart';

class HandelingView extends StatelessWidget {
  HandelingView({
    Key? key,
    required this.statusRequest,
    required this.widget,
    required this.reLoad,
  }) : super(key: key);

  final StatusRequest statusRequest;
  Widget widget;
  Future Function() reLoad;

  @override
  Widget build(BuildContext context) {
    if (statusRequest == StatusRequest.loading) {
      return const Center(child: CircularProgressIndicator());
    } else if (statusRequest == StatusRequest.success) {
      return widget;
    } else if (statusRequest == StatusRequest.failure) {
      return const Center(child: Text('No Data'));
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No Connection'),
            SizedBox(
              height: Get.height / 15,
            ),
            IconButton(
              onPressed: reLoad,
              icon: Icon(
                Icons.refresh,
                color: Get.theme.primaryColor,
              ),
            )
          ],
        ),
      );
    }
  }
}
