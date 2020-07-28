import 'package:flutter/material.dart';
import 'package:food_app/src/widgets/button.dart';

class AddFoodItem extends StatefulWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 60.0, horizontal: 16.0),
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
                GestureDetector(
                  child: Button(btnTxt: "Add Food Item"),
                  onTap: () {
                    if (_foodItemFormKey.currentState.validate()) {
                      _foodItemFormKey.currentState.save();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField(String hint, {int maxLine = 1}) {
    return TextFormField(
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
      onChanged: (String value) {
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
