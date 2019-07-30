import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:http/http.dart' as http;

class CreateInviteModel {
  static const platform = const MethodChannel('samples.flutter.dev/ssoanywhere');
  var txtInviteTitle;
  var txtInviteCategory;
  var inviteImg;
  var txtInviteDesc;
  var noInvitees;
  var txtDate, txtTime;
  var txtVanue;

  var inviteAPI         = AppStringClass.APP_BASE_URL+"work/action.php";
  var categoryImageAPI  = AppStringClass.APP_BASE_URL+"work/action.php?cat_img=";

  Map<String, String> headers = new Map();

  setInviteTitle(var title) => this.txtInviteTitle = title;

  setInviteCategory(var Category) => this.txtInviteCategory = Category;

  setInviteImg(var img) => this.inviteImg = img;

  setInviteDesc(var desc) => this.txtInviteDesc = desc;

  setInviteNo(var no_Invitees) => this.noInvitees = no_Invitees;

  setInviteDate(var date) => this.txtDate = date;

  setInviteTime(var time) => this.txtTime = time;

  setInviteVanue(var vanue) => this.txtVanue = vanue;

  Future<String> checkRefreshToken() {
    return _getRefreshToken(); // ignore: argument_type_not_assignable
  }

  Future<String> invitePostRequest(String token) {
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+token;
    var encoding = Encoding.getByName('utf-8');
    return postInvites(inviteAPI,headers: headers, body: getPostParams(),encoding: encoding)
        .then((String res) {
      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
        return res;
    });
  }


  Future<String> postInvites(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null || response.body!="") {
        throw new Exception("Error while fetching data");
      }else if(response.body == "token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  String getPostParams(){
    String action='action=invite&';
    String title = 'title='+txtInviteTitle+'&';
    String category = 'category_id='+txtInviteCategory+'&';
    String categoryImage = 'image_id='+inviteImg+'&';
    String descr = 'description='+txtInviteDesc+'&';
    String noinvite = 'allowed_member_count='+noInvitees+'&';
    String date = 'created_date='+txtDate+'&';
    String time = 'time='+txtTime+'&';
    String vanue = 'venue_id='+txtVanue+'&';
    String user = 'created_by=App';
    return action+title+category+categoryImage+descr+noinvite+date+time+vanue;
  }

  Future<String> getCategoryPicUrls(String category) {
    return http.get(categoryImageAPI+category)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return response.body;
    });
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

}
