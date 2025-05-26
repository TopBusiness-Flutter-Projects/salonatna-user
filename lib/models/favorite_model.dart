import 'package:app/models/product_model.dart';
import 'package:flutter/foundation.dart';

class Favorites {
  int? favCount;
  List<Product> favItems = [];

  Favorites();

  Favorites.fromJson(Map<String, dynamic> json) {
    try {
      favCount = json['fav_count'] != null ? int.parse('${json['fav_count']}') : null;
      favItems = json['fav_items'] != null && json['fav_items'] != [] ? List<Product>.from(json['fav_items'].map((x) => Product.fromJson(x))) : [];
    } catch (e) {
      debugPrint("Exception - FavoritesModel.dart - Favorites.fromJson():$e");
    }
  }
}
