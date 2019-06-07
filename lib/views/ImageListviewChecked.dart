import 'package:flutter/material.dart';

class ImageListViewChecked extends StatefulWidget {
  List<Product> imageList;
  ImageSelectedCallbacks callback;
  ImageListViewCheckedState ILC;
  ImageListViewChecked(ImageSelectedCallbacks callback,List<Product> imageList)
      : callback=callback,imageList=imageList,super(key: new ObjectKey(""));

  @override
  ImageListViewCheckedState createState() {
    ILC =  new ImageListViewCheckedState(callback,imageList);
    return ILC;
  }
}

abstract class ImageSelectedCallbacks {
  void imgSelected(int id);
}

class Product {
  String categoryImage;
  int isCheck;
  int isGroup;
  Product(this.categoryImage, this.isCheck,this.isGroup);
}

class ImageListViewCheckedState extends State<ImageListViewChecked> {
  List<Product> imageList = new List<Product>();
  ImageSelectedCallbacks callback;
  int groupChoice;

  ImageListViewCheckedState(this.callback, this.imageList);


  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
//                  padding: new EdgeInsets.symmetric(vertical: 8.0),

        children: imageList.map((Product product) {
          return new Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: new AssetImage(product.categoryImage),
                  fit: BoxFit.cover,
                ),
              ),
              alignment: Alignment(1, 1),
              child:
              new Radio(value: product.isCheck,
                  groupValue: groupChoice,
                  onChanged: _handleRadioValueChange1)
          );
        }).toList(),
      ),
    );
  }

  void _handleRadioValueChange1(int value) {
//    setState(() {
    groupChoice = value;
    callback.imgSelected(value);
//    });
  }
}