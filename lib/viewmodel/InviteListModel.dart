import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'Invite.dart';
import 'ProfileDataUpdate.dart';

class InviteListModel{
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  static final InviteListModel inviteListModel=new InviteListModel();
  Map<String, String> headers = new Map();

  var uri ="http://convergepro.xyz/meetupapi/work/action.php?action=getinvites";
  var joinLeaveuri ="http://convergepro.xyz/meetupapi/work/action.php?action=joinleave";

  var uriSelectedCategories = "http://convergepro.xyz/meetupapi/work/action.php?action=getinvites&category_id=";
  var uriFutureInvites = "http://www.convergepro.xyz/meetupapi/work/action.php?action=myinvites&futr=futr";
  var uriPastInvites = "http://www.convergepro.xyz/meetupapi/work/action.php?action=myinvites&past=past";

  var startInviteuri ="http://convergepro.xyz/meetupapi/work/action.php?action=startinvite";
  var hostlogUri = "http://www.convergepro.xyz/meetupapi/work/action.php?action=invitelog";
  var commentRateUri = "http://www.convergepro.xyz/meetupapi/work/action.php?action=comments";

  static List<Invite> inviteList = new List();

  InviteListModel();

  InviteListModel getInstance(){
    return inviteListModel;
  }

  List<Invite> getInviteList(){
    return inviteList;
  }

  Future<String> checkRefreshToken() {
    return _getRefreshToken(); // ignore: argument_type_not_assignable
  }

  Future<String> inviteGetRequest() async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getInvite(uri,user)
        .then((String res) {

      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }

  Future<String> SelectedinviteGetRequest(String categories) async {
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getInvite(uriSelectedCategories+categories, user)
        .then((String res) {
      if (res == null) throw new Exception("error");
      return res;
    });
  }


  Future<String> upcomingInviteRequest() async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getInvite(uriFutureInvites,user)
        .then((String res) {

      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }
  Future<String> pastInviteRequest() async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getInvite(uriPastInvites,user)
        .then((String res) {

      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }

  Future<String> getInvite(String url,String token) {
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+token;
    return http.post(url,headers: headers).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      print("response" +response.body);
      return response.body;
    });
  }

  void getListInvites(List<dynamic> webList){
    inviteList.clear();
    for(int i =0;i<webList.length;i++){
      Invite inv=new Invite();
      inv.sid(webList[i]["id"]);
      inv.setTitle(webList[i]["title"]);
      inv.setDescription(webList[i]["description"]);
      inv.setCategory_id(webList[i]["category_id"]);
      inv.setTime(webList[i]["time"]);
      inv.setVenue(webList[i]["venue"]);
      inv.setImage(webList[i]["image"]);
      inv.setAllowed_member_count(webList[i]["allowed_member_count"]);
      inv.setCreated_by(webList[i]["created_by"]);
      inv.setCreated_date(webList[i]["created_date"]);
      inv.setFirst_name(webList[i]["first_name"]);
      inv.setinviteStarted(webList[i]["start_invite"]);
      if(null!=webList[i]["log"] && webList[i]["log"]!="")
        inv.setHostlog(webList[i]["log"][0]["comment"]);
      inv.setJoined(webList[i]["joined"]);
      inv.setisJoined(webList[i]["is_joined"]);
      inv.setisLogged(webList[i]["isLoged"]);
      inv.setisCommented(webList[i]["is_commented"]);
      inv.setJoineList(getInviteJoinees(webList[i]["joinees"],webList[i]["user_comments"]));
      inviteList.add(inv);
    }
  }

  List<InviteJoinees> getInviteJoinees(List<dynamic> jList,Map jCommentsList){
    List<InviteJoinees> iJoined=new List<InviteJoinees>();
    if(null!=jList) {
      for (int i = 0; i < jList.length; i++) {
        InviteJoinees inviteJoinees = new InviteJoinees();
        inviteJoinees.setsg_id(jList[i]["sg_id"]);
        inviteJoinees.setName(jList[i]["first_name"]);
        inviteJoinees.setDesignation(jList[i]["designation"]);
        inviteJoinees.setProfile_img(jList[i]["profile_img"]);
        if(null!=jCommentsList) {
          List<dynamic> jComments = jCommentsList[jList[i]["sg_id"]];
          if (null != jComments && jComments.length > 0){
            if (null != jComments[0]["comment"] && jComments[0]["comment"] != ""){
              inviteJoinees.setComment(jComments[0]["comment"]);}
            if (null != jComments[0]["rating"] && jComments[0]["rating"] != "")
              inviteJoinees.setRate(jComments[0]["rating"]);
            if (null != jComments[0]["commented_date"] && jComments[0]["commented_date"] != "")
              inviteJoinees.setcomment_date(jComments[0]["commented_date"]);
          }
        }
        iJoined.add(inviteJoinees);
      }
      return iJoined;
    }
  }

  Future<String> _getRefreshToken() async {
    String refreshToken;
    try {
      final String result = await platform.invokeMethod('getRefreshToken');
      refreshToken = result;
    } on PlatformException catch (e) {
      refreshToken = "Error : '${e.code}'.";
    }
    return refreshToken;
  }

  void clearInviteList() {
    return (inviteList!=null && inviteList.length>0) ? inviteList.clear() : new List();
  }

  Future<String> joinOrLeave(String doLeave,String inv_id) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+user;
    return http.post(joinLeaveuri,body: getJoinLeavePostParams(doLeave,inv_id),headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  Future<String> startInvite(String inv_id) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+user;
    return http.post(startInviteuri,body: 'invite_id='+inv_id,headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  Future<String> postHostLog(String inv_id,String hostlog) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+user;
    return http.post(hostlogUri,body: 'invite_id='+inv_id+'&comment='+hostlog,headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  Future<String> rateAndComment(String inv_id,String comment,String rate) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+user;
    return http.post(commentRateUri,body: 'invite_id='+inv_id+'&comment='+comment+'&rating='+rate,headers: headers).then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }


  String getJoinLeavePostParams(String doLeave,String inv_id){
    String action='action='+doLeave+'&';  //action = join to attend invite or leave to exit invite
    String invid = 'invite_id='+inv_id;
      return action+invid;
    }


}