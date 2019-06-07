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

  var inviteAPI         = "http://convergepro.xyz/meetupapi/work/action.php";
  var categoryImageAPI  = "http://convergepro.xyz/meetupapi/work/action.php?cat_img=";

  Map<String, String> headers = new Map();

  setInviteTitle(var title) => this.txtInviteTitle = title;

  setInviteCategory(var Category) => this.txtInviteCategory = Category;

  setInviteImg(var img) => this.inviteImg = img;

  setInviteDesc(var desc) => this.txtInviteDesc = desc;

  setInviteNo(var no_Invitees) => this.noInvitees = no_Invitees;

  setInviteDate(var date) => this.txtDate = date;

  setInviteTime(var time) => this.txtTime = time;

  setInviteVanue(var vanue) => this.txtVanue = vanue;


  Future<String> invitePostRequest() {
    headers['Content-type']="application/x-www-form-urlencoded";
    var encoding = Encoding.getByName('utf-8');
    return postInvites(inviteAPI,headers: headers, body: getPostParams(),encoding: encoding)
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
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
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
}
