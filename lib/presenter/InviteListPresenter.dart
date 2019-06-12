

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
          inviteListCallBack.updateViews(inviteListModel.getInviteList());
        }
      }else{
        inviteListCallBack.updateViews(inviteListModel.getInviteList());
      }
    }on Exception catch(error) {
      inviteListCallBack.showError();
    }
  }
}

abstract class InviteListCallBack{
   void updateViews(List<Invite> invitedata);
   void showError();
}
