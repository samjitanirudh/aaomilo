import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

class CreateInviteModel {
  var txtInviteTitle;
  var txtInviteCategory;
  var inviteImg;
  var txtInviteDesc;
  var noInvitees;
  var txtDate, txtTime;
  var txtVanue;
  var inviteAPI="";

  getInviteTitle() => txtInviteTitle;

  getInviteCategory() => txtInviteCategory;

  getInviteImg() => inviteImg;

  gettxtInviteDesc() => txtInviteDesc;

  getNoInvitees() => noInvitees;

  getDate() => txtDate;

  getTime() => txtTime;

  getVanue() => txtVanue;

  setInviteTitle(var title) => this.txtInviteTitle = title;

  setInviteCategory(var Category) => this.txtInviteCategory = Category;

  setInviteImg(var img) => this.inviteImg = img;

  setInviteDesc(var desc) => this.txtInviteDesc = desc;

  setInviteNo(var no_Invitees) => this.noInvitees = no_Invitees;

  setInviteDate(var date) => this.txtDate = date;

  setInviteTime(var time) => this.txtTime = time;

  setInviteVanue(var vanue) => this.txtVanue = vanue;

  Future<String> invitePostRequest(CreateInviteModel cInvite) {
    return postInvites(inviteAPI, body: getPostParams())
        .then((String res) {
      print(res.toString());
      if (res == null) throw new Exception("error");
      return res;
    });
  }


  Future<String> postInvites(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = 100; //response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return response.body;
    });
  }

  String getPostParams(){
    String title = 'title='+this.getInviteTitle()+'&';
    String category = 'category='+this.getInviteCategory()+'&';
    String categoryImage = 'categoryImg='+this.getInviteImg()+'&';
    String descr = 'descr='+this.gettxtInviteDesc()+'&';
    String noinvite = 'max_invite='+this.getNoInvitees()+'&';
    String date = 'invite_date='+this.getDate()+'&';
    String time = 'invite_time='+this.getTime()+'&';
    String vanue = 'invite_vanue='+this.getVanue();
    return title+category+categoryImage+descr+noinvite+date+vanue;
  }

}
