import 'package:flutter_meetup_login/viewmodel/CreateInviteModel.dart';
import 'dart:convert';

class CreateInvitePreseter{

  InviteCallbacks _callbacks;
  CreateInviteModel _createInviteModel;

  CreateInvitePreseter(InviteCallbacks callback){
    _callbacks=callback;
    _createInviteModel=new CreateInviteModel();
  }

  CreateInviteOnClick(Map params) async {
    try{
      _createInviteModel = setParams(params);
      String response = await _createInviteModel.invitePostRequest();
      if(response!=null) {
        _callbacks.createdSuccessfull();
      }
    }on Exception catch(error) {
      _callbacks.showLoginError();
    }
  }

  CreateInvite_getCategoryImages(String category) async {
    try{
      _createInviteModel = new CreateInviteModel();
      String response = await _createInviteModel.getCategoryPicUrls(category);
      if(response!=null) {
        List<dynamic> images= json.decode(Uri.decodeFull(response));
        _callbacks.updateCategoryImages(images);
//        print(images[0]['imagepath']);
      }
    }on Exception catch(error) {

    }
  }


  CreateInviteModel setParams(Map param)
  {
    CreateInviteModel inviteModel=new CreateInviteModel();
    inviteModel.setInviteTitle(param['title']);
    inviteModel.setInviteCategory(param['category']);
    inviteModel.setInviteImg(param['img']);
    inviteModel.setInviteDesc(param['desc']);
    inviteModel.setInviteDate(param['date']);
    inviteModel.setInviteTime(param['time']);
    inviteModel.setInviteNo(param['max_invite']);
    inviteModel.setInviteVanue(param['vanue']);
    return inviteModel;
  }
}

abstract class InviteCallbacks {
  void createdSuccessfull();
  void showLoginError();
  void updateCategoryImages(List<dynamic> images);
}