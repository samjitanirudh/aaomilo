
import 'dart:convert';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/InviteListModel.dart';

class InviteListPresenter{

  InviteListCallBack inviteListCallBack;

  InviteDetailCallBack inviteDetailCallBack;

  InviteListModel inviteListModel=InviteListModel().getInstance();

  InviteListPresenter(InviteListCallBack inviteListCallBack){
    this.inviteListCallBack=inviteListCallBack;
  }

  setInviteDetailCallBack(InviteDetailCallBack invcallback){
    inviteDetailCallBack=invcallback;
  }

  GetInviteList() async{
    try{
      if(inviteListModel.getInviteList() != null && inviteListModel.getInviteList().length>1) {
        inviteListCallBack.updateViews(inviteListModel.getInviteList());
      }else{
        String res = await inviteListModel.inviteGetRequest();
        if (res != null && res!="sessionExpired") {
          inviteListModel.getListInvites(json.decode(res));
          inviteListCallBack.updateViews(inviteListModel.getInviteList());
        }else{
          inviteListCallBack.showErrorDialog(res);
        }
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

  joinOrLeave(String doLeave,String invid) async{
    try{
      String response = await inviteListModel.joinOrLeave(doLeave,invid);
      if(response!=null && !response.contains("Error : ")) {
        inviteDetailCallBack.updateViews(response);
      }
      else{
        inviteDetailCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteDetailCallBack.showErrorDialog("sessionExpired");
    }
  }

}

abstract class InviteListCallBack{
   void updateViews(List<Invite> invitedata);
   void showError();
   void showErrorDialog(String error);
}

abstract class InviteDetailCallBack{
  void updateViews(String status);
  void showError();
  void showErrorDialog(String error);
}
