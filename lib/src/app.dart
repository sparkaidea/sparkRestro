import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../src/screens/main_screen.dart';
import '../src/scoped-model/main_model.dart';
import '../src/admin/pages/add_food_item.dart';

class App extends StatelessWidget {
  final MainModel mainModel = MainModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: mainModel,
      child: MaterialApp(
        title: "Food Delivery App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blueAccent,
        ),
        home: MainScreen(model: mainModel),
        //home: AddFoodItem(),
      ),
    );
  }
}
