import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quotes_with_sql/controller/quotes_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    QuotesController controller = Get.put(QuotesController());
    return Scaffold(
body: Obx(
  () =>  LiquidSwipe.builder(itemBuilder: (context, index) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(fit: BoxFit.cover,image: AssetImage(controller.preselectedImages[index]))
    ),
  );
  }, itemCount: controller.quotes.length, onPageChangeCallback: (activePageIndex) {
controller.liquidController.animateToPage(page: activePageIndex);
print(activePageIndex);
},
positionSlideIcon: 0.8,
slideIconWidget: Icon(Icons.arrow_back_ios,color: Colors.white,),
waveType: WaveType.liquidReveal,
liquidController: controller.liquidController,

fullTransitionValue: 300, // Reduced this value for better control
enableSideReveal: false,
preferDragFromRevealedArea: false,
enableLoop: false,
ignoreUserGestureWhileAnimating: true,),
),
    );
  }
}
