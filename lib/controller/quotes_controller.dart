import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:quotes_with_sql/api/api_services.dart';
import 'package:quotes_with_sql/database/sql_services.dart';
import 'package:quotes_with_sql/model/quotes_model.dart';
import 'dart:math';
class QuotesController extends GetxController
{
RxList<QuotesModel> mainQuotes = <QuotesModel>[].obs;
RxList<QuotesModel> quotes = <QuotesModel>[].obs;
LiquidController liquidController = LiquidController();
RxList<String> preselectedImages = <String>[].obs;
RxList<QuotesModel> favouriteQuotes = <QuotesModel>[].obs;
RxList<String> favouriteCategories = <String>[].obs;
RxInt indexForGlobalUse = 0.obs;
Timer? _timer;



List category = [
  {
    "category" : "General",
    "image": 'assets/images/bg.jpeg',
  },
  {
    "category" : "Life",
    "image": 'assets/images/life1.jpg',
  },{
    "category" : "Love",
    "image": 'assets/images/love1.jpg',
  },{
    "category" : "Success",
    "image":  'assets/images/success1.jpg',
  },{

    "category" : "Motivation",
    "image":  'assets/images/motivation1.jpg',
  },{
    "category" : "Happiness",
    "image": 'assets/images/life5.jpg',
  },{
    "category" : "Powerful",
    "image":      'assets/images/powerful2.jpg',

  },{
    "category" : "Friendship",
    "image":   'assets/images/friendship1.jpg',
  },{
    "category" : "Humor",
    "image":   'assets/images/funny2.jpg',
  },








];

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
fetchFavouriteCategories();
}

Future<void> loadData() async {

  // Start fetching data
  double _progress = 0;
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(milliseconds: 100),
          (Timer timer) {
        EasyLoading.showProgress(_progress,
            status: '${(_progress * 100).toStringAsFixed(0)}%');
        _progress += 0.06;

        if (_progress >= 1) {
          _timer?.cancel();
          EasyLoading.dismiss();
        }
      });
  List json = await ApiServices.apiServices.fetchData();


  // Process the data

  mainQuotes.value = json.map((e) => QuotesModel.fromJson(e)).toList();
  mainQuotes.shuffle();
  quotes.value = mainQuotes;



  // Final step: preload images
  preloadRandomImages();

  // Finish loading

  EasyLoading.dismiss();
}



void toggleIsFavourite(int index) async {
  var quote = quotes[index];
  if (quote.isFavorite) {
    // Remove from favorites
    quote.isFavorite = false;

    int? id = await DatabaseHelper.databaseHelper.getQuoteId(quote);
    if (id != null) {
      await deleteFavourite(id);
    }
  } else {
    // Add to favorites
    quote.isFavorite = true;
    await addFavourite(quote);
  }
  quotes[index] = quote;
  quotes.refresh();
}


void preloadRandomImages() {
  final random = Random();
  preselectedImages.value = List.generate(quotes.length, (index) {
    final category = quotes[index].category;
    final images = categoryImages[category];
    if (images == null || images.isEmpty) return '';
    return images[random.nextInt(images.length)];
  });
  print(preselectedImages.length);
}

Future<void> addFavourite(QuotesModel quote)
async {
  bool exists = await DatabaseHelper.databaseHelper.doesQuoteExist(quote);

  if (!exists) {
    await DatabaseHelper.databaseHelper.insertQuote(quote);
  }
}

Future<void> fetchQuotes(String category)
async {
  quotes.value=await DatabaseHelper.databaseHelper.fetchFavoriteQuotesByCategory(category);
  quotes.refresh();
  liquidController.jumpToPage(page: 0);
  preloadRandomImages();
}

Future<void> fetchFavouriteCategories()
async {
  favouriteCategories.value=await DatabaseHelper.databaseHelper.getFavoriteCategories();
  favouriteCategories.refresh();

 }

 Future<void> deleteFavourite(int id)
 async {
   await DatabaseHelper.databaseHelper.deleteQuote(id);
 }


}