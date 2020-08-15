import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../../src/scoped-model/main_model.dart';
import '../../../src/widgets/show_dialog.dart';
import '../../../src/models/food_model.dart';
import '../../../src/widgets/button.dart';

class AddFoodItem extends StatefulWidget {
  final Food food;

  AddFoodItem({this.food});
  @override
  _AddFoodItemState createState() => _AddFoodItemState();
}

class _AddFoodItemState extends State<AddFoodItem> {
  String title;
  String category;
  String description;
  String price;
  String discount;

  GlobalKey<FormState> _foodItemFormKey = GlobalKey();
  GlobalKey<ScaffoldState> _scaffoldStateKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop(false);
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldStateKey,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Text(
              widget.food != null ? "Update Food Item" : "Add Food Item",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              // width: MediaQuery.of(context).size.width,
              // height: MediaQuery.of(context).size.height,
              child: Form(
                key: _foodItemFormKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 15.0),
                      width: MediaQuery.of(context).size.width,
                      height: 150.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: AssetImage("assets/images/noimage.png"),
                          )),
                    ),
                    _buildFormField("Food Title"),
                    _buildFormField("Category"),
                    _buildFormField("Description", maxLine: 4),
                    _buildFormField("Price"),
                    _buildFormField("Discount"),
                    SizedBox(height: 50.0),
                    ScopedModelDescendant(
                      builder: (BuildContext context, Widget child,
                          MainModel model) {
                        return GestureDetector(
                          child: Button(
                              btnTxt: widget.food != null
                                  ? "Update Food Item"
                                  : "Add Food Item"),
                          onTap: () {
                            onSubmit(model.addFood, model.updateFood);
                            if (model.isLoading) {
                              showLoadingIndicator(
                                  context,
                                  widget.food != null
                                      ? "Updating food..."
                                      : "Adding food...");
                            }
                          },
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onSubmit(Function addFood, Function updateFood) async {
    if (_foodItemFormKey.currentState.validate()) {
      _foodItemFormKey.currentState.save();

      if (widget.food != null) {
        Map<String, dynamic> updateFoodItem = {
          "title": title,
          "category": category,
          "description": description,
          "price": double.parse(price),
          "discount": discount != null ? double.parse(discount) : 0.0,
        };
        final bool response = await updateFood(updateFoodItem, widget.food.id);
        if (response) {
          Navigator.of(context).pop(); // to remove the alret dialog
          Navigator.of(context).pop(response);
        } else {
          Navigator.of(context).pop();
          SnackBar snackbar = SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.red,
            content: Text(
              "Failed to updated Food Item",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackbar);
        }
      } else {
        final Food food = Food(
          name: title,
          category: category,
          description: description,
          price: double.parse(price),
          discount: double.parse(discount),
        );

        bool value = await addFood(food);
        if (value) {
          Navigator.of(context).pop();
          SnackBar snackbar = SnackBar(
            content: Text("Food item successfully added."),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackbar);
        } else {
          Navigator.of(context).pop();
          SnackBar snackbar = SnackBar(
            content: Text("Failed to add Food Item."),
          );
          _scaffoldStateKey.currentState.showSnackBar(snackbar);
        }
      }
    }
  }

  Widget _buildFormField(String hint, {int maxLine = 1}) {
    return TextFormField(
      initialValue: widget.food != null && hint == "Food Title"
          ? widget.food.name
          : widget.food != null && hint == "Description"
              ? widget.food.description
              : widget.food != null && hint == "Category"
                  ? widget.food.category
                  : widget.food != null && hint == "Price"
                      ? widget.food.price.toString()
                      : widget.food != null && hint == "Discount"
                          ? widget.food.discount.toString()
                          : "",
      decoration: InputDecoration(hintText: "$hint"),
      maxLines: maxLine,
      keyboardType: hint == "Price" || hint == "Discount"
          ? TextInputType.number
          : TextInputType.text,
      validator: (String value) {
        if (value.isEmpty && hint == "Food Title") {
          return "The food title is required";
        }

        if (value.isEmpty && hint == "Category") {
          return "The category is required";
        }

        if (value.isEmpty && hint == "Description") {
          return "The description is required";
        }

        if (value.isEmpty && hint == "Price") {
          return "The price is required";
        }
      },
      onSaved: (String value) {
        if (hint == "Food Title") {
          title = value;
        }

        if (hint == "Category") {
          category = value;
        }

        if (hint == "Description") {
          description = value;
        }

        if (hint == "Price") {
          price = value;
        }

        if (hint == "Discount") {
          discount = value;
        }
      },
    );
  }
}
