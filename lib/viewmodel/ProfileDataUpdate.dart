import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ProfileDataModel {

  var profileAPI         = "http://convergepro.xyz/meetupapi/work/action.php";
  var profilePicAPI         = "http://convergepro.xyz/meetupapi/profile_pics/";

  Map<String, String> headers = new Map();

  UserProfile userProfile=UserProfile().getInstance();

  getUserPorfilePicUrl()=>this.profilePicAPI+base64Encode(utf8.encode(userProfile.sg_id));

  Future<String> profilePostRequest() {
    headers['Content-type']="application/x-www-form-urlencoded";
    var encoding = Encoding.getByName('utf-8');
    return postProfile(profileAPI,headers: headers, body: getProfilePostParams(),encoding: encoding)
        .then((String res) {
      if (res == null) throw new Exception("error");
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
    String sgid = base64Encode(utf8.encode(sg_id));
    return getUser(profileAPI+"?action=getuserprofile&sgid="+sgid);
  }

  Future<String> getUser(String url) {
    return http.post(url).then((http.Response response) {

      final int statusCode = response.statusCode;
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
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
      userdata["profileimg"]=this.profilePicAPI+userProfile.getUserPorfilePicUrl();
      userProfile.setUserFirstName(userdata['name']);
      userProfile.setUserEmail(userdata['email']);
      userProfile.setUserContact(userdata['contact_no']);
      userProfile.setProject(userdata['project']);
      userProfile.setAbout(userdata['about_me']);
      userProfile.setSkills(userdata['skills']);
      userProfile.setInterest(userdata['intereset']);
      userProfile.setDesignation(userdata['designation']);
    }
    return userdata;
  }

}

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
  static UserProfile userProfile=new UserProfile();

  UserProfile();

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

  Future<String> getLoggedInUser() async{
    var prefs = await SharedPreferences.getInstance();
    String myString = prefs.getString('user') ?? '';
    return myString;
  }

  saveLoggedInUser(String user) async {
    UserProfile().getInstance().setSGID(user);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', user);
  }


}