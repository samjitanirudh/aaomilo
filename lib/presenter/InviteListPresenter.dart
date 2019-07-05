
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

  GetInviteList(selectedCategoryList, String inviteType ) async{
    try{
      if(inviteListModel.getInviteList().length<1) {
        String res;
       res = await inviteListModel.inviteGetRequest();

        if (res != null) {
          inviteListModel.getListInvites(json.decode(res));
          inviteListCallBack.updateViews(inviteListModel.getInviteList());
        }else{
          inviteListCallBack.showErrorDialog(res);
        }
      }else{
        if(selectedCategoryList!= null) {
          String res = await inviteListModel.SelectedinviteGetRequest(selectedCategoryList);
          if (res != null) {
            inviteListModel.getListInvites(json.decode(res));
            inviteListCallBack.updateViews(inviteListModel.getInviteList());
          }else{
            inviteListCallBack.showErrorDialog(res);
          }
        }

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
        inviteDetailCallBack.updateViews(response);
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
  void updateViews(String status);
  void showError();
  void showErrorDialog(String error);
}
