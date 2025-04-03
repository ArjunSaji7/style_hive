import 'package:flutter/cupertino.dart';

class WishlistProvider extends ChangeNotifier {

  List<String> fav1 = [];
  List<String> fav2 = [];
  List<String> fav3 = [];
  List<String> fav4 = [];
  List<String> productIdList = [];

  List<String> get image => fav1;
  List<String> get price => fav2;
  List<String> get name => fav3;
  List<String> get rating => fav4;
  List<String> get productId => productIdList;
  //
  void toggleFavorite(String productId, String image, String price, String name, String rating) {
    final isExist = productIdList.contains(productId);
    if (isExist) {
      productIdList.remove(productId);
      fav1.remove(image);
      fav2.remove(price);
      fav3.remove(name);
      fav4.remove(rating);
      print('remove');
    } else {
      productIdList.add(productId);
      fav1.add(image);
      fav2.add(price);
      fav3.add(name);
      fav4.add(rating);
      print('add');
    }
    notifyListeners();
  }

  bool symbol(String symbols) {
    final isExist = productIdList.contains(symbols);
    return isExist;
  }
}


