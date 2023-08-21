import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:un_splash/routes.dart';
import 'core/services/services.dart';
import 'initialbinding.dart';
import 'package:flutter/rendering.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(
    DevicePreview(
      builder: (context) => const MyApp(),
      enabled: false,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Images',
      theme: ThemeData(
        useMaterial3: true,
        backgroundColor: Colors.white,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        primarySwatch: Colors.blue,
      ),
      initialBinding: InitialBinding(),
      getPages: routes,
    );
  }
}
