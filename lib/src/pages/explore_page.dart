import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../admin/pages/add_food_item.dart';
import '../scoped-model/main_model.dart';
import '../widgets/show_dialog.dart';

import '../widgets/food_item_card.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  GlobalKey<ScaffoldState> _explorePageScaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _explorePageScaffoldKey,
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: ScopedModelDescendant<MainModel>(
          builder: (scopedContext, child, model) {
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: RefreshIndicator(
                onRefresh: model.fetchFoods,
                child: ListView.builder(
                  itemBuilder: (listContext, index) {
                    return GestureDetector(
                      onTap: () async {
                        final bool response = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddFoodItem(
                              food: model.foods[index],
                            ),
                          ),
                        );
                        if (response) {
                          SnackBar snackbar = SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: Theme.of(context).primaryColor,
                            content: Text(
                              "Food item successfully updated.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          );
                          _explorePageScaffoldKey.currentState
                              .showSnackBar(snackbar);
                        }
                        ;
                      },
                      onDoubleTap: () {
                        showLoadingIndicator(context, "Deleting food item...");
                        model.deleteFood(model.foods[index].id).then((value) {
                          Navigator.of(context).pop();
                        });
                      },
                      child: FoodItemCard(
                        title: model.foods[index].name,
                        description: model.foods[index].description,
                        price: model.foods[index].price.toString(),
                      ),
                    );
                  },
                  itemCount: model.foodLength,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
