import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotes_with_sql/pages/splash/intro_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {

    Timer(Duration(seconds: 2), () {
      Get.to(IntroPage());
    });
    return Scaffold(
      body: Center(

        child: Image.asset('assets/images/quote-512.png',height: 500,width: 150,),
      ),
    );
  }
}
