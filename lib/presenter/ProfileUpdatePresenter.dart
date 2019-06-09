import 'dart:convert';
import 'dart:io';

import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

class ProfileUpdatePresenter{

  ProfileUpdateCallbacks profileCallback;
  ProfileDataModel profileUpdate;

  ProfileUpdatePresenter(ProfileUpdateCallbacks proCallback){
    profileCallback = proCallback;
    profileUpdate = new ProfileDataModel();
  }

  PostProfileData(Map params,File _image) async {
    try {
      List<int> imageBytes = await _image.readAsBytes();
      String imgEncoded = Base64Encoder().convert(imageBytes);
      params['profilepic'] = imgEncoded;
      profileUpdate.setParams(params);
      String response = await profileUpdate.profilePostRequest();
      if(response!=null&& response=="insert") {
        profileCallback.updatedSuccessfull();
      }else{
        profileCallback.showLoginError();
      }
    } on Exception catch (error) {
      profileCallback.showLoginError();
    }
  }
}

abstract class ProfileUpdateCallbacks {
  void updatedSuccessfull();
  void showLoginError();
  Future<String> profileImageBase64(File image);
}