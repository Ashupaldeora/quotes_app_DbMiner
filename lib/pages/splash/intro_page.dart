import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quotes_with_sql/pages/home/home_page.dart';

class IntroPage extends StatefulWidget {
  IntroPage({super.key});

  @override
  State<IntroPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<IntroPage> with TickerProviderStateMixin {
  LiquidController liquidController = LiquidController();
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late AssetImage image ;

  @override
  void initState() {
    super.initState();
     image = AssetImage('assets/images/bg.jpeg');
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();

    _offsetAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start position (off-screen to the right)
      end: Offset(0.0, 0), // End position (on-screen)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: this.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black
                      .withOpacity(0), // Make sure container is transparent
                ),
              ),
              Center(
                child: SlideTransition(
                  position: _offsetAnimation,
                  child: Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text.rich(
                              textAlign: TextAlign.center,
                              TextSpan(children: [
                                TextSpan(
                                  text: 'Start your journey to a\n',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500)),
                                ),
                                TextSpan(
                                  text: 'more ',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w500)),
                                ),
                                TextSpan(
                                  text: 'positive and\nfullfilling life',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 24,
                                          color: Colors.deepOrange,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ])),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offAll(const HomePage());

                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          margin: EdgeInsets.only(bottom: 50),
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(15)),
                          alignment: Alignment.center,
                          child: Text(
                            "Get Started",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  // fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// onPageChangeCallback: (activePageIndex) {
// setState(() {
// print(activePageIndex);
// });
// },
// positionSlideIcon: 0.8,
// slideIconWidget: Icon(Icons.arrow_back_ios),
// waveType: WaveType.liquidReveal,
// liquidController: liquidController,
// fullTransitionValue: 300, // Reduced this value for better control
// enableSideReveal: true,
// preferDragFromRevealedArea: true,
// enableLoop: true,
// ignoreUserGestureWhileAnimating: true,
