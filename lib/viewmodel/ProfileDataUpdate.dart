import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

class ProfileDataModel {

  var profileAPI         = "http://convergepro.xyz/meetupapi/work/action.php";
  var profilePicAPI         = "http://convergepro.xyz/meetupapi/profile_pics/";

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
  setDesignation(var designation) => this.designation= designation;
  setUserProfilePicName(var picName) => this.profileImageName= picName;
  getUserPorfilePicUrl()=>this.profilePicAPI+base64Encode(utf8.encode(this.sg_id));

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
    setUserFirstName(param['firstname']);
    setUserLastName(param['lastname']);
    setAbout(param['about']);
    setSkills(param['skill']);
    setInterest(param['intereset']);
    setSGID(param['sgid']);
    setUserProfilePic(param['profilepic']);
    setDesignation(param['_designation']);
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
      userdata["designation"]=webList[i]['designation'];
      userdata["about_me"]=webList[i]['about_me'];
      userdata["skills"]=webList[i]['skills'];
      userdata["interest"]=webList[i]['interest'];
      setUserFirstName(userdata['name']);
      setAbout(userdata['about_me']);
      setSkills(userdata['skills']);
      setInterest(userdata['intereset']);
      setDesignation(userdata['designation']);
    }
    return userdata;
  }

}
