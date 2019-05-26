import 'package:flutter/material.dart';

class ImageListViewChecked extends StatefulWidget {
  final Product product;

  ImageListViewChecked(Product product)
      : product = product,
        super(key: new ObjectKey(product));

  @override
  ImageListViewCheckedState createState() {
    return new ImageListViewCheckedState(product);
  }
}

class Product {
  String categoryImage;
  int isCheck;
  int isGroup;

  Product(this.categoryImage, this.isCheck,this.isGroup);
}

class ImageListViewCheckedState extends State<ImageListViewChecked> {
  final Product product;
  ImageListViewCheckedState(this.product);
  int radioState=-1;
  @override
  Widget build(BuildContext context) {
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
      new Radio(value: product.isCheck, groupValue: radioState, onChanged: _handleRadioValueChange1)
//      new Checkbox(
//          value: product.isCheck,
//          onChanged: (bool value) {
//            setState(() {
//              product.isCheck = value;
//            });
//          }),
    );
  }

  void _handleRadioValueChange1(int value) {
    setState(() {
      radioState = value;
    });
  }

}
