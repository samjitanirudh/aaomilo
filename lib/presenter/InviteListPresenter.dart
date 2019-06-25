
import 'dart:convert';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/InviteListModel.dart';

class InviteListPresenter{

  InviteListCallBack inviteListCallBack;

  InviteListModel inviteListModel=InviteListModel().getInstance();

  InviteListPresenter(InviteListCallBack inviteListCallBack){
    this.inviteListCallBack=inviteListCallBack;
  }

  GetInviteList() async{
    try{
      if(inviteListModel.getInviteList().length<1) {
        String res = await inviteListModel.inviteGetRequest();
        if (res != null) {
          inviteListModel.getListInvites(json.decode(res));
          inviteListCallBack.updateViews(inviteListModel.getInviteList());
        }else{
          inviteListCallBack.showErrorDialog(res);
        }
      }else{
        inviteListCallBack.updateViews(inviteListModel.getInviteList());
      }
    }on Exception catch(error) {
      inviteListCallBack.showError();
    }
  }
  clearInviteList(){
    try{
      inviteListModel.clearInviteList();
    }on Exception catch(error) {
      inviteListCallBack.showError();
    }
  }
  refreshToken() async {
    try{
      String response = await inviteListModel.checkRefreshToken();
      print("SSOResponse: "+ response);
      if(response!=null && !response.contains("Error : ")) {
        inviteListCallBack.updateViews(inviteListModel.getInviteList());
      }
      else{
        inviteListCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteListCallBack.showErrorDialog("sessionExpired");
    }
  }
}

abstract class InviteListCallBack{
   void updateViews(List<Invite> invitedata);
   void showError();
   void showErrorDialog(String error);
}
