import 'package:flutter_meetup_login/viewmodel/CreateInviteModel.dart';

class CreateInvitePreseter{

  InviteCallbacks _callbacks;
  CreateInviteModel _createInviteModel;

  CreateInvitePreseter(InviteCallbacks callback){
    _callbacks=callback;
    _createInviteModel=new CreateInviteModel();
  }

  CreateInviteOnClick(Map params) async {
    try{
      String response = await _createInviteModel.invitePostRequest(setParams(params));
      if(response!=null) {
        _callbacks.createdSuccessfull();
      }
    }on Exception catch(error) {
      _callbacks.showLoginError();
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
}