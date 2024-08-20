import 'package:doneapp/shared_module/constants/asset_urls.constants.shared.dart';
import 'package:doneapp/shared_module/controllers/controller.shared.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GifSplashPage_Core extends StatefulWidget {
  const GifSplashPage_Core({super.key});

  @override
  State<GifSplashPage_Core> createState() => _GifSplashPage_CoreState();
}

class _GifSplashPage_CoreState extends State<GifSplashPage_Core> {

  final sharedController = Get.find<SharedController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(const Duration(seconds: 2), () async {
      sharedController.setInitialScreen();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ASSETS_SPLASH_ANIMATION),
      ),
    );
  }
}
