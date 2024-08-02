import 'package:get/get.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quotes_with_sql/api/api_services.dart';
import 'package:quotes_with_sql/model/quotes_model.dart';
import 'dart:math';
class QuotesController extends GetxController
{
RxList<QuotesModel> quotes = <QuotesModel>[].obs;
LiquidController liquidController = LiquidController();
RxList<String> preselectedImages = <String>[].obs;

Map categoryImages = {
  'Life': [
    'assets/images/life1.jpg',
    'assets/images/life2.jpg',
    'assets/images/life3.jpg',
    'assets/images/life4.jpg',

  ],
  'Love':[
    'assets/images/love1.jpg',
    'assets/images/love2.jpg',
    'assets/images/love3.jpg',
    'assets/images/love4.jpg',
  ],
  'Success':[
    'assets/images/success1.jpg',
    'assets/images/success2.jpg',
    'assets/images/success3.jpg',
  ],
  'Motivation':[
    'assets/images/motivation1.jpg',
    'assets/images/motivation2.jpg',
    'assets/images/motivation3.jpg',
    'assets/images/motivation4.jpg',
  ],
  'Happiness':[
    'assets/images/happiness1.jpg',
    'assets/images/life5.jpg',
  ],
  'Powerful':[
    'assets/images/powerful1.jpg',
    'assets/images/powerful2.jpg',
    'assets/images/powerful3.jpg',
    'assets/images/powerful4.jpg',
  ],
  'Friendship':[
'assets/images/friendship1.jpg',
'assets/images/friendship2.jpg',
'assets/images/friendship3.jpg',
  ],
  'Humor':[
    'assets/images/funny1.jpg',
    'assets/images/funny2.jpg',
    'assets/images/funny3.jpg',
    'assets/images/funny4.jpg',
  ]
};

@override
void onInit()
{
  super.onInit();

loadData();

}

Future<void> loadData()
async {
List json = await ApiServices.apiServices.fetchData();
quotes.value = json.map((e) => QuotesModel.fromJson(e)).toList();
preloadRandomImages();
}




void preloadRandomImages() {
  final random = Random();
  preselectedImages.value = List.generate(quotes.length, (index) {
    final category = quotes[index].category;
    final images = categoryImages[category];
    if (images == null || images.isEmpty) return '';
    return images[random.nextInt(images.length)];
  });
}


}