import 'package:flutter/material.dart';

class ImageListViewChecked extends StatefulWidget {
  List<Product> imageList;
  ImageSelectedCallbacks callback;
  ImageListViewCheckedState ILC;
  FormFieldState<String> stateForm;
  ImageListViewChecked(ImageSelectedCallbacks callback,List<Product> imageList,FormFieldState<String> state)
      : callback=callback,imageList=imageList,stateForm=state,super(key: new ObjectKey(""));


  @override
  ImageListViewCheckedState createState() {
    ILC =  new ImageListViewCheckedState(callback,imageList,stateForm);
    return ILC;
  }
}

abstract class ImageSelectedCallbacks {
  void imgSelected(int id,FormFieldState<String> state);
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
  FormFieldState<String> stateForm;
  String imageUrl = "http://convergepro.xyz/meetupapi/cat_img/";

  ImageListViewCheckedState(this.callback, this.imageList,this.stateForm);


  @override
  Widget build(BuildContext context) {
    return new Container(
      height: 150.0,
      child: ListView(
        scrollDirection: Axis.horizontal,
//                  padding: new EdgeInsets.symmetric(vertical: 8.0),

        children: imageList.map((Product product) {
          bool loaded=false;
          NetworkImage nI= new NetworkImage(imageUrl+product.categoryImage);
          nI.resolve(new ImageConfiguration()).addListener((_,__){
            if(mounted){
                setState(() {
                  loaded=true;
                });
            }
          });
          return new Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:  loaded?nI:AssetImage("assets/images/pulse.gif"),
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
    callback.imgSelected(value,stateForm);
//    });
  }
}