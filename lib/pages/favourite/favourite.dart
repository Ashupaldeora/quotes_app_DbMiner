import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotes_with_sql/controller/quotes_controller.dart';

Future favouriteSheet(BuildContext context,QuotesController controller)
{
  return showModalBottomSheet(isScrollControlled: true,showDragHandle: true,context: context, builder: (context) => Container(
    height: MediaQuery.of(context).size.height-120,
    width: double.infinity,
    // alignment: Alignment.centerLeft,
    // color: Colors.yellow,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(height: 35,width: 35,decoration: BoxDecoration(color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),child:  Icon(Icons.close),),
          ),
          SizedBox(height: 10,),

          Text(
            "Favourite Categories",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,

                fontSize: 30,
                fontWeight: FontWeight.w600,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            "Choose the areas you want to grow in",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black,

                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20,),
          Expanded(
            child: GridView.builder(shrinkWrap: true,itemCount: controller.favouriteCategories.length,gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 10
            ), itemBuilder: (context, index) {

              final category = controller.favouriteCategories[index];

              // Find the image path associated with the category
              final image = controller.category.firstWhere(
                    (cat) => cat["category"] == category,
                orElse: () => {"image": ''},
              )["image"];




              return GestureDetector
            (
              onTap: () async {

               await controller.fetchQuotes(controller.favouriteCategories[index]);
               controller.quotes.refresh();


                Get.back();
              },
              child: Container(
                height: 100,
                width: 100,
                padding: EdgeInsets.only(bottom: 15,left: 10),
                alignment: Alignment.bottomLeft,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(fit: BoxFit.cover,image: AssetImage(image)),


                ),
                child: Text(
                  controller.favouriteCategories[index],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.white,

                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );},),
          )
        ],
      ),
    ),
  ),);


}
