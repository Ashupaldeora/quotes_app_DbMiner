import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quotes_with_sql/controller/quotes_controller.dart';
import 'package:quotes_with_sql/pages/categories/categories.dart';
import 'package:quotes_with_sql/pages/favourite/favourite.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});


  @override
  Widget build(BuildContext context) {
    QuotesController controller = Get.put(QuotesController());

    return Scaffold(
      body: Obx(() {
        if (controller.quotes.isEmpty) {
          // EasyLoading.show();
          return Container(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:  AssetImage('assets/images/bg.jpeg'),
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

              ],
            ),
          );

        }else
          {
            EasyLoading.dismiss();
          }


        return Stack(
          alignment: Alignment.center,
          children: [
            LiquidSwipe.builder(

              itemBuilder: (context, index) {
                index = index % controller.quotes.length;

                // Ensure the index is within bounds
                if (index >= controller.quotes.length) {
                  return Container(); // Return an empty container if index is out of bounds
                }
                final textPainter = TextPainter(
                  text: TextSpan(
                    text: "- ${controller.quotes[index].author}",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  textDirection: TextDirection.ltr,
                )..layout();

                final textWidth = textPainter.width;
                final underlineWidth = textWidth * 0.6;

                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(controller.preselectedImages[index]),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [


                          // Stroke and Fill for Quotes Text
                          Stack(
                            // alignment: Alignment.center,
                            children: [
                              // Stroke
                              Text(
                                controller.quotes[index].quote,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 2
                                      ..color = Colors.black,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              // Fill
                              Text(
                                controller.quotes[index].quote,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),

                          SizedBox(height: 30,),

                          // Stroke and Fill for Author Text
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,

                                children: [
                                  Stack(
                                    children: [
                                      // Stroke
                                      Text(
                                        "- ${controller.quotes[index].author}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            foreground: Paint()
                                              ..style = PaintingStyle.stroke
                                              ..strokeWidth = 2
                                              ..color = Colors.black,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      // Fill
                                      Text(
                                        "- ${controller.quotes[index].author}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 1,),
                                  Container(
                                    height: 2.5,
                                    margin: EdgeInsets.only(left: 10),
                                    width: underlineWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 20,)
                            ],
                          ),

                          // this is where you have to do the changes


                        ],
                      ),
                    ),
                  ),
                );
              },

              itemCount: controller.quotes.length,
              onPageChangeCallback: (activePageIndex) {

                print(activePageIndex);
                print(controller.quotes.length);

                  controller.indexForGlobalUse.value = activePageIndex % controller.quotes.length;



              },
              positionSlideIcon: 0.8,
              slideIconWidget: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),

              waveType: WaveType.liquidReveal,
              liquidController: controller.liquidController,
              fullTransitionValue: 300,
              enableSideReveal: false,
              preferDragFromRevealedArea: false,
              enableLoop: false,
              ignoreUserGestureWhileAnimating: true,
            ),

            Positioned(bottom: 200,child: Text(controller.quotes[controller.indexForGlobalUse.value].category,style:GoogleFonts.poppins(
                textStyle:TextStyle(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 16)
            ),)),
            Positioned(
              top: MediaQuery.of(context).padding.top + 50,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Categories Button
                  GestureDetector(
                    onTap: () => categorySheet(context,controller),
                    child: Container(
                      height: 37,
                      width: 120,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.widgets_outlined,size: 15,),
                          SizedBox(width: 5,),
                          Text("Categories",style: GoogleFonts.poppins(
                              textStyle:TextStyle(fontWeight: FontWeight.w600)
                          ),),
                        ],
                      ),
                    ),
                  ),

                  // Palette and Settings Buttons
                  Row(
                    children: [
                      // Palette Button
                      GestureDetector(
                        onTap: () {
                  controller.fetchFavouriteCategories();
                  favouriteSheet(context, controller);
                        },
                        child: Container(

                          height: 37,
                          width: 37,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(10)
                          ),child: Text("Fav",style: GoogleFonts.poppins(
                            textStyle:TextStyle(fontWeight: FontWeight.w600)
                        ),),),
                      ),
                      SizedBox(width: 10,),
                      // Settings Button
                      Container(
                        height: 37,
                        width: 37,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10)
                        ),child: Icon(Icons.settings,size: 20,),),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 70,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Share Button
                  Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        shape: BoxShape.circle
                    ),child: Icon(Icons.ios_share,),),
                  SizedBox(width: 50,),
                  // Like Button
                  GestureDetector(
                    onTap: () {
                      controller.toggleIsFavourite(controller.indexForGlobalUse.value);
                      controller.fetchFavouriteCategories();

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          shape: BoxShape.circle
                      ),child: (controller.quotes[controller.indexForGlobalUse.value].isFavorite)?Icon(Icons.favorite_outlined,color: Colors.red,):Icon(Icons.favorite_outline,),),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
