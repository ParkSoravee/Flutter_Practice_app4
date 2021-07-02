import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_app_course1_app4/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token) async {
    final url = Uri.parse(
      'https://flutter-app1-eadee-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token',
    );
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.patch(url,
          body: json.encode({
            'isFavorite': isFavorite,
          }),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
        // throw HttpException('Can not toggle favorite!');
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }

}
