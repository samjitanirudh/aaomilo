import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProfileDataModel {

  var profileAPI         = "http://convergepro.xyz/meetupapi/work/action.php";
  Map<String, String> headers = new Map();

  var first_name="";
  var last_name="";
  var about_me="";
  var skills="";
  var interest="";
  var sg_id="";
  var email_id="";
  var contact_no="";
  var project_name="";
  var designation="";
  var profileImage;
  var profileImageName;

  setUserFirstName(var fName) => this.first_name= fName;
  setUserLastName(var lName) => this.last_name= lName;
  setAbout(var about) => this.about_me= about;
  setSkills(var skill) => this.skills= skill;
  setInterest(var interest) => this.interest= interest;
  setSGID(var sgID) => this.sg_id= sgID;
  setUserProfilePic(var pic) => this.profileImage= pic;
  setUserProfilePicName(var picName) => this.profileImageName= picName;

  Future<String> profilePostRequest() {
    headers['Content-type']="application/x-www-form-urlencoded";
    var encoding = Encoding.getByName('utf-8');
    return postProfile(profileAPI,headers: headers, body: getProfilePostParams(),encoding: encoding)
        .then((String res) {
      final jsonResponse = json.decode(res);
      print(jsonResponse);
      if (res == null) throw new Exception("error");
      return res;
    });
  }


  Future<String> postProfile(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: Uri.encodeFull(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return response.body;
    });
  }

  void setParams(Map param)
  {
    setUserFirstName(param['firstname']);
    setUserLastName(param['lastname']);
    setAbout(param['about']);
    setSkills(param['skill']);
    setInterest(param['intereset']);
    setSGID(param['sgid']);
    setUserProfilePic(param['profilepic']);
    setUserProfilePicName(param['profilepicname']);
  }


  String getProfilePostParams(){
    String action='action=updateprofile&';
    String sgid = 'sg_id='+sg_id+'&';
    String fname = 'first_name='+first_name+'&';
    String lname = last_name!=null?'last_name='+last_name+'&':'last_name=&';
    String about = 'about_me='+about_me+'&';
    String skill = 'skills='+skills+'&';
    String intrst = 'interest='+interest+'&';
    String desig = 'designation='+designation+'&';
    String email = 'email_id='+email_id+'&';
    String contact = 'contact_no='+contact_no+'&';
    String proname = 'profile_image='+profileImage+'&';
    String proimgname = 'profile_image_name='+profileImageName+'&';
    return action+sgid+fname+lname+about+skill+intrst+desig+email+contact+proname+proimgname;
  }

//  String getProfileImagePostParams(){
//    String action='action=profile_pic&';
//    String profile = 'profile_img='+profileImage+'&';
//    String sg_id = 'sg_id='+this.sg_id+'&';
//    return action+profile+sg_id;
//  }

}
