import 'dart:convert';
import 'dart:io';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

class ProfileUpdatePresenter{

  ProfileUpdateCallbacks profileCallback;
  ProfileDataModel profileUpdate;
  String loggedInUser="";
  UserProfile userProfile=new UserProfile();

  ProfileUpdatePresenter(ProfileUpdateCallbacks proCallback){
    profileCallback = proCallback;
    profileUpdate = new ProfileDataModel();
  }

  PostProfileData(Map params,File _image) async {
    try {

      if(null!=_image){
        List<int> imageBytes = await _image.readAsBytesSync();
        String imgEncoded =  base64Encode(imageBytes);
        params['profilepic'] = Uri.encodeQueryComponent(imgEncoded);
      }

      profileUpdate.setParams(params);
      String response = await profileUpdate.profilePostRequest();

      if(response!=null && response!="sessionExpired") {
        profileCallback.updatedSuccessfull(response);
      }else{
        profileCallback.showErrorDialog(response);
      }

    } on Exception catch (error) {
      profileCallback.showErrorDialog(error.toString());
    }

  }

  getProfileData() async{
    try{
      loggedInUser=await userProfile.getLoggedInUser();
      String webList= await profileUpdate.userGetRequest(loggedInUser);

      if( webList!="sessionExpired")
        profileCallback.updateView(profileUpdate.getUserDetails(json.decode(webList)));
      else
        profileCallback.showErrorDialog(webList);
    }on Exception catch (error) {
      profileCallback.showErrorDialog(error.toString());
    }
  }

}

abstract class ProfileUpdateCallbacks {
  void updatedSuccessfull(String msg);
  void showErrorDialog(String error);
  void updateView(Map userdetails);
}