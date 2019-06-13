import 'dart:convert';

import 'package:flutter_meetup_login/viewmodel/Categories.dart';

class CategoriesPresenter {

  CategoryClass _categoriesModel;


  CreateInvite_getCategoryImages(String category) async {
    try{
      _categoriesModel = new CategoryClass();
      String response = await _categoriesModel.getCategoryPicUrls(category);
      if(response!=null) {
        List<dynamic> images= json.decode(Uri.decodeFull(response));

//        print(images[0]['imagepath']);
      }
    }on Exception catch(error) {

    }
  }

}