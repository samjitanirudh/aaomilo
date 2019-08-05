import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginModel.dart';

class UserProfile{

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
  var profileImage="";
  var profileImageName="";
  var profilePicAPI      = AppStringClass.APP_BASE_URL+"work/action.php?action=profilepic";
  var profileupdate=false;

  static UserProfile userProfile=new UserProfile();

  resetUserProfile(){
    this.first_name="";
    this.last_name="";
    this.about_me="";
    this.skills="";
    this.interest="";
    this.sg_id="";
    this.email_id="";
    this.contact_no="";
    this.project_name="";
    this.designation="";
    this.profileImage="";
    this.profileImageName="";
    this.profileupdate=false;
  }

  UserProfile getInstance(){
    if(null!=userProfile)
      return userProfile;
    else
      return userProfile=new UserProfile();
  }

  setUserFirstName(var fName) => this.first_name= fName;
  setUserEmail(var email) => this.email_id= email;
  setUserContact(var contact) => this.contact_no= contact;
  setAbout(var about) => this.about_me= about;
  setSkills(var skill) => this.skills= skill;
  setInterest(var interest) => this.interest= interest;
  setProject(var project) => this.project_name= project;
  setSGID(var sgID) => this.sg_id= sgID;
  setUserProfilePic(var pic) => this.profileImage= pic;
  setDesignation(var designation) => this.designation= designation;
  setUserProfilePicName(var picName) => this.profileImageName= picName;
  getUserPorfilePicUrl()=>base64Encode(utf8.encode(this.sg_id+".jpg"));
  setProfileImageUpdate(var viewed) => this.profileupdate= viewed;

  getUserDataInMap(UserProfile uProfile){
    Map userdata = new Map();
    userdata["name"]=uProfile.first_name;
    userdata["designation"]=uProfile.designation;
    userdata["about_me"]=uProfile.about_me;
    userdata["skills"]=uProfile.skills;
    userdata["interest"]=uProfile.interest;
    userdata["email"]=uProfile.email_id;
    userdata["contact_no"]=uProfile.contact_no;
    userdata["profileimg"] = profilePicAPI;
    userdata["project"]= uProfile.project_name;
    return userdata;
  }


  Future<String> getLoggedInUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isTokenExpiried(prefs.getString('timestamp'))){
      String myString = prefs.getString('user') ?? '';
      return myString;
    }
    else {
      String response = await LoginModel().refreshToken();
      if(!response.contains("Error") && (response!=null || response.compareTo("")!=0)){
        Map sessionList=json.decode(response);
        saveLoggedInUser(sessionList["access_token"].toString());
        return sessionList["access_token"].toString();
      }
    }
  }

  Future<bool> saveLoggedInUser(String user) async {
    UserProfile().getInstance().setSGID(user);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('timestamp', new DateTime.now().toString());
    return prefs.setString('user', user);
  }

  bool isTokenExpiried(String timestamp){
    DateTime tokenTime = DateTime.parse(timestamp);
    DateTime currentTime = new DateTime.now();
    Duration difference = currentTime.difference(tokenTime);
    int elapsedtime = difference.inMinutes;
    if(elapsedtime>=9)
      return true;
    else
      return false;
  }


}