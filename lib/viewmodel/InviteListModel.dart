import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'Invite.dart';

class InviteListModel{
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  static final InviteListModel inviteListModel=new InviteListModel();


  var uri ="http://convergepro.xyz/meetupapi/work/action.php?action=getinvites";
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
  Future<String> inviteGetRequest() {
    return getInvite(uri)
        .then((String res) {
          print(res);
      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }

  Future<String> getInvite(String url) {
    return http.post(url).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
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
      inv.setJoined(webList[i]["joined"]);
      inviteList.add(inv);
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
}