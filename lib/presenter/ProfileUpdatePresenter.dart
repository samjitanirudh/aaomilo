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
      List<int> imageBytes = await _image.readAsBytesSync();
      String imgEncoded =  base64Encode(imageBytes);
      params['profilepic'] = Uri.encodeQueryComponent(imgEncoded);
      profileUpdate.setParams(params);
      String response = await profileUpdate.profilePostRequest();
      if(response!=null) {
        profileCallback.updatedSuccessfull(response);
      }else{
        profileCallback.showErrorDialog();
      }
    } on Exception catch (error) {
      profileCallback.showErrorDialog();
    }
  }

  getProfileData(String userid) async{
    try{
      String webList= await profileUpdate.userGetRequest(userid);
      profileCallback.updateView(profileUpdate.getUserDetails(json.decode(webList)));
    }on Exception catch (error) {
      profileCallback.showErrorDialog();
    }
  }

}

abstract class ProfileUpdateCallbacks {
  void updatedSuccessfull(String msg);
  void showErrorDialog();
  void updateView(Map userdetails);
}