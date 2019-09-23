
import 'dart:convert';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/InviteListModel.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

class InviteListPresenter{

  InviteListCallBack inviteListCallBack;

  InviteDetailCallBack inviteDetailCallBack;

  InviteDetailCommentUpdateCallback _commentUpdateCallback;

  InviteListModel inviteListModel=InviteListModel().getInstance();

  InviteListPresenter(InviteListCallBack inviteListCallBack){
    this.inviteListCallBack=inviteListCallBack;
  }

  setInviteDetailCallBack(InviteDetailCallBack invcallback){
    inviteDetailCallBack=invcallback;
  }

  setInviteDetailCommentUpdate(InviteDetailCommentUpdateCallback invcallback){
    _commentUpdateCallback=invcallback;
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
        inviteListModel.getUpcomingListInvites(json.decode(response));
        inviteListCallBack.updateViewsUpcomingInvites(inviteListModel.getUpcomingInviteList());

      }
      else{
        inviteListCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteListCallBack.showErrorDialog("sessionExpired");
    }
  }

  pastEvents() async {
    try{
      String response = await inviteListModel.pastInviteRequest();

      if(response!=null && !response.contains("sessionExpired")) {
        inviteListModel.getPastListInvites(json.decode(response));
        inviteListCallBack.updateViewsPastInvites(inviteListModel.getPastInviteList());
      }
      else{
        inviteListCallBack.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      inviteListCallBack.showErrorDialog("sessionExpired");
    }
  }

  hostLog(String invid,String hostlog) async{
    try{
      String response = await inviteListModel.postHostLog(invid,hostlog);
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

  commentAndRate(String invid,String comment, String rate) async{
    try{
      String response = await inviteListModel.rateAndComment(invid,comment,rate);
      if(response!=null && !response.contains("sessionExpired")) {
        _commentUpdateCallback.commentedUpdated(response);
      }
      else{
        _commentUpdateCallback.showErrorDialog("sessionExpired");
      }
    }on Exception catch(error) {
      _commentUpdateCallback.showErrorDialog("sessionExpired");
    }
  }

}

abstract class InviteListCallBack{
   void updateViews(List<Invite> invitedata);
   void updateViewsPastInvites(List<Invite> invitedata);
   void updateViewsUpcomingInvites(List<Invite> invitedata);
   void showError();
   void showErrorDialog(String error);
}

abstract class InviteDetailCallBack{
  void updateViewsJoinLeave(String status);
  void updateViewsStartInvite(String status);
  void showError();
  void showErrorDialog(String error);
}

abstract class InviteDetailCommentUpdateCallback{
  void commentedUpdated(String status);
  void showErrorDialog(String error);
}