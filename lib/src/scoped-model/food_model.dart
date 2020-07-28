import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import '../models/food_model.dart';
import 'package:http/http.dart' as http;

class FoodModel extends Model {
  List<Food> _foods = [];

  List<Food> get foods {
    return List.from(_foods);
  }

  void addFood(Food food) {
    _foods.add(food);
  }

  void fetchFood() {
    http
        .get("http://10.0.2.2:51044/api/restaurants")
        .then((http.Response response) {
      //print("Fetching data: ${response.body} ");
      final List fetchedData = json.decode(response.body);
      final List<Food> fetchedFoodItems = [];
      fetchedData.forEach((data) {
        Food food = Food(
          id: data["id"].toString(),
          category: data["categoryId"].toString(),
          discount: double.parse(data["discount"].toString()),
          imagePath: data["imagePath"].toString(),
          name: data["title"].toString(),
          price: double.parse(data["price"].toString()),
          ratings: 12.0,
        );
        fetchedFoodItems.add(food);
      });

      _foods = fetchedFoodItems;
    });
  }
}
