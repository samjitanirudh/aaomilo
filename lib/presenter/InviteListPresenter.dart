
import 'dart:convert';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/InviteListModel.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

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

  GetInviteList(bool fetchNew) async{
    try{
      if(inviteListModel.getInviteList() != null && inviteListModel.getInviteList().length>1 && !fetchNew) {
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
      if(response!=null && !response.contains("sessionExpired")) {
        inviteDetailCallBack.updateViewsJoinLeave(response);
      }
      else{
        inviteDetailCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteDetailCallBack.showErrorDialog("sessionExpired");
    }
  }

  startInvite(String invid) async{
    try{
      String response = await inviteListModel.startInvite(invid);
      if(response!=null && !response.contains("sessionExpired")) {
        inviteDetailCallBack.updateViewsStartInvite(response);
      }
      else{
        inviteDetailCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteDetailCallBack.showErrorDialog("sessionExpired");
    }
  }

  upComingEvents() async {
    try{
      String response = await inviteListModel.upcomingInviteRequest();
      if(response!=null && !response.contains("sessionExpired")) {
        inviteListModel.getListInvites(json.decode(response));
        inviteListCallBack.updateViews(inviteListModel.getInviteList());
      }
      else{
        inviteDetailCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteDetailCallBack.showErrorDialog("sessionExpired");
    }
  }

  pastEvents() async {
    try{
      String response = await inviteListModel.pastInviteRequest();
      if(response!=null && !response.contains("sessionExpired")) {
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
  void updateViewsJoinLeave(String status);
  void updateViewsStartInvite(String status);
  void showError();
  void showErrorDialog(String error);
}
