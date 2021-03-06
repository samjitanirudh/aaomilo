import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:http/http.dart' as http;

import 'ProfileDataUpdate.dart';
import 'UserProfile.dart';
class ProfileDataModel {

  var profileAPI         = AppStringClass.APP_BASE_URL+"work/action.php";
  var profilePicAPI      = AppStringClass.APP_BASE_URL+"work/action.php?action=profilepic";

  Map<String, String> headers = new Map();

  UserProfile userProfile=UserProfile().getInstance();

  getUserPorfilePicUrl()=>this.profilePicAPI+base64Encode(utf8.encode(userProfile.sg_id));

  Future<String> profilePostRequest() {
    headers['Content-type']="application/x-www-form-urlencoded";
    var encoding = Encoding.getByName('utf-8');
    return postProfile(profileAPI,headers: headers, body: getProfilePostParams(),encoding: encoding)
        .then((String res) {
      if (res == null) throw new Exception("error");
      else if(res=="sessionExpired")
        return res;
      else
      return jsonDecode(res);
    });
  }


  Future<String> postProfile(String url, {Map headers, body, encoding}) {
    return http
        .post(url, body: Uri.encodeFull(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body=="token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

  void setParams(Map param)
  {
    userProfile.setUserFirstName(param['firstname']);
    userProfile.setProject(param["project"]);
    userProfile.setUserEmail(param["email"]);
    userProfile.setUserContact(param["contact_no"]);
    userProfile.setAbout(param['about']);
    userProfile.setSkills(param['skill']);
    userProfile.setInterest(param['intereset']);
    userProfile.setSGID(param['sgid']);
    userProfile.setUserProfilePic(param['profilepic']);
    userProfile.setDesignation(param['_designation']);
    userProfile.setUserProfilePicName(param['profilepicname']);
  }


  String getProfilePostParams(){
    String action='action=updateprofile&';
    String sgid = 'sg_id='+userProfile.sg_id+'&';
    String fname = 'first_name='+userProfile.first_name+'&';
    String project = 'project='+userProfile.project_name+'&';
    String about = 'about_me='+userProfile.about_me+'&';
    String skill = 'skills='+userProfile.skills+'&';
    String intrst = 'interest='+userProfile.interest+'&';
    String desig = 'designation='+userProfile.designation+'&';
    String email = 'email_id='+userProfile.email_id+'&';
    String contact = 'contact_no='+userProfile.contact_no+'&';
    if(null!=userProfile.profileImage){
      String proname = 'profile_image='+userProfile.profileImage+'&';
      String proimgname = 'profile_image_name='+userProfile.profileImageName+'&';
      return action+sgid+fname+project+about+skill+intrst+desig+email+contact+proname+proimgname;
    }else{
      return action+sgid+fname+project+about+skill+intrst+desig+email+contact;
    }


  }


  Future<String> userGetRequest(String sg_id) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getUser(profileAPI+"?action=getuserprofile",user);
  }

  Future<String> userProfileGetRequest(String sg_id) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    return getUser(profileAPI+"?action=getuserprofile&user="+sg_id,user);
  }

  Future<String> getUser(String url,String token) {
    headers['Authorization']="Berear "+token;
    return http.post(url,headers: headers).then((http.Response response) {
      print("response "+response.body);
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body=="token expired"){
       return "sessionExpired";
      }
      return response.body;
    });
  }

  Map getUserDetails(List<dynamic> webList){
    Map userdata =new Map();
    for(int i =0;i<webList.length;i++){
      userdata["name"]=webList[i]['first_name'];
      userdata["email"]=webList[i]['email_id'];
      userdata["contact_no"]=webList[i]['contact_no'];
      userdata["project"]=webList[i]['project'];
      userdata["designation"]=webList[i]['designation'];
      userdata["about_me"]=webList[i]['about_me'];
      userdata["skills"]=webList[i]['skills'];
      userdata["interest"]=webList[i]['interest'];
      userdata["profileimg"]=this.profilePicAPI+"&user_id=";
    }
    return userdata;
  }

  Map getLoggedUserDetails(List<dynamic> webList){
    Map userdata =new Map();
    for(int i =0;i<webList.length;i++){
      userdata["name"]=webList[i]['first_name'];
      userdata["email"]=webList[i]['email_id'];
      userdata["contact_no"]=webList[i]['contact_no'];
      userdata["project"]=webList[i]['project'];
      userdata["designation"]=webList[i]['designation'];
      userdata["about_me"]=webList[i]['about_me'];
      userdata["skills"]=webList[i]['skills'];
      userdata["interest"]=webList[i]['interest'];
      userdata["profileimg"]=this.profilePicAPI;
      userProfile.setUserFirstName(userdata['name']);
      userProfile.setUserEmail(userdata['email']);
      userProfile.setUserContact(userdata['contact_no']);
      userProfile.setProject(userdata['project']);
      userProfile.setAbout(userdata['about_me']);
      userProfile.setSkills(userdata['skills']);
      userProfile.setInterest(userdata['intereset']);
      userProfile.setDesignation(userdata['designation']);
      userProfile.profileupdate=true;
    }
    return userdata;
  }

  postFCMToken(String token) async{
    String user = await UserProfile().getInstance().getLoggedInUser();
    postFCMTokenAPI(user,token);
  }

  Future<String> postFCMTokenAPI(String token,String fcmtoken) {
    String body = "fcm="+fcmtoken;
    headers['Content-type']="application/x-www-form-urlencoded";
    headers['Authorization']="Berear "+token;
    var encoding = Encoding.getByName('utf-8');
    return http
        .post(profileAPI+"?action=notificationtoken", body: Uri.encodeFull(body), headers: headers, encoding: encoding)
        .then((http.Response response) {
      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }else if(response.body=="token expired"){
        return "sessionExpired";
      }
      return response.body;
    });
  }

}

