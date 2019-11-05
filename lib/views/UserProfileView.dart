import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';
import 'package:url_launcher/url_launcher.dart';

class UserProfileView extends StatefulWidget {
  String userid;
  String navigationFrom;

  UserProfileView({Key key, this.userid,this.navigationFrom}) : super(key: key);

  @override
  UserProfileViewState createState() {
    // TODO: implement createState
    UserProfileViewState _myProfilePage = new UserProfileViewState(this.userid,this.navigationFrom);
    return _myProfilePage;
  }
}

class UserProfileViewState extends State<UserProfileView>
    implements ProfileUpdateCallbacks {
  String userid;
  String navigationFrom;

  UserProfileViewState(this.userid,this.navigationFrom);

  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    color: Colors.white,
  );
  Map _formdata = new Map();
  ProfileUpdatePresenter profileUpdatePresenter;
  var _formview;
  bool _isLoading = false;
  BuildContext bContext;
  String user_id;
  String ProfilePicApi =
      AppStringClass.APP_BASE_URL + "work/action.php?action=profilepic";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileUpdatePresenter = new ProfileUpdatePresenter(this);
    if(navigationFrom=="InviteDetails" && userid!=""){
      getUserProfileData(userid);
    } else if(UserProfile().getInstance().first_name==""){
      getUserProfileData("");
    }else{
      loadViewWithData(UserProfile().getInstance().getUserDataInMap(UserProfile().getInstance()));
    }
  }

  getUserProfileData(String user_id) {
    _formdata["name"] = "";
    _formdata["designation"] = "";
    _formdata["about_me"] = "";
    _formdata["skills"] = "";
    _formdata["interest"] = "";
    _formdata["email"] = "";
    _formdata["contact_no"] = "";
    _formdata["project"] = "";
    _isLoading = true;
    if (user_id == "" || user_id == null)
      profileUpdatePresenter.getProfileData();
    else
      profileUpdatePresenter.getUserProfileData(user_id);
  }

  loadViewWithData(Map userdetails){
    _formdata["name"] = userdetails["name"]==""?"-":userdetails["name"];
    _formdata["designation"] = userdetails["designation"]==""?"-":userdetails["designation"];
    _formdata["about_me"] = userdetails["about_me"]==""?"-":userdetails["about_me"];
    _formdata["skills"] = userdetails["skills"]==""?"No skills":userdetails["skills"];
    _formdata["interest"] = (userdetails["interest"]==""||userdetails["interest"]==null)?"-":userdetails["interest"];
    if(UserProfile().getInstance().profileupdate)
      _formdata["profileimg"] = UserProfile().getInstance().profilePicAPI+"&"+new DateTime.now().millisecondsSinceEpoch.toString();
    else
      _formdata["profileimg"] = UserProfile().getInstance().profilePicAPI;
    _formdata["email"]= userdetails["email"]==""?"-":userdetails["email"];
    _formdata["contact_no"]= userdetails["contact_no"]==""?"-":userdetails["contact_no"];
    _formdata["project"]= userdetails["project"]==""?"-":userdetails["project"];
    UserProfile().getInstance().setProfileImageUpdate(false);
    if(userid!="")
      ProfilePicApi = ProfilePicApi+"&user_id="+userid.toString();
  }

  @override
  void showErrorDialog(String errorMesage) {
    if (errorMesage == "sessionExpired") {
      UserProfile().getInstance().resetUserProfile(); //
      Navigator.of(context).pushReplacementNamed('/Loginscreen');
    } else
      ; //_showDialog(bContext,"View profile", errorMesage,true);
  }

  @override
  void updateView(Map userdetails) {
    // TODO: implement updateView
    if (mounted) {
      setState(() {
        if (userdetails.length > 0) {
          loadViewWithData(userdetails);
        }
        _isLoading = false;
      });
    }
  }

  @override
  void updatedSuccessfull(String msg) {
    // TODO: implement updatedSuccessfull
  }

  tokenExpired() {
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    bool showMenu=false;
    if(userid==null || userid==""){
      showMenu=true;
    }
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.PurpleVColor,
          title: Text("Profile"),
          actions: showMenu
              ? <Widget>[
            new IconButton(
              icon: new Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed('/UpdateUserProfileScreen');
              },
            ),
            new IconButton(
              icon: new Icon(Icons.lock_open),
              onPressed: () {
                tokenExpired();
              },
            ),
          ]
              : <Widget>[],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body: new Stack(children: mainViewContainer()));
  }

  mainViewContainer() {
    _formview = SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new Container(
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                headerSectionView(),
                aboutSectionView(),
                profileImageSectionView(),
                contactsSectionView(),
                skillsOrHobbieSectionView("Skills",_formdata["skills"]),
                skillsOrHobbieSectionView("Interest",_formdata["interest"])
              ],
            ),
          ),
        ));
    var view = new List<Widget>();
    view.add(_formview);
    if (_isLoading) {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: Colors.grey),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
      view.add(modal);
    }
    return view;
  }

  headerSectionView() {
    return new Container(
      color: AppColors.PurpleVColor,
      child: new Stack(
        children: <Widget>[
          new Container(
            height: 100,
            width: MediaQuery
                .of(bContext)
                .size
                .width,
            margin: EdgeInsets.fromLTRB(50, 10, 20, 10),
            padding: EdgeInsets.fromLTRB(70, 10, 10, 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                  _formdata["name"],
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightBlueVColor),
                ),
                new Text(_formdata["designation"],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColors.PurpleVColor)),
                new Text(_formdata["project"],
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                        color: AppColors.PurpleVColor))
              ],
            ),
          ),
          new Container(
            width: 84,
            height: 84,
            margin: EdgeInsets.fromLTRB(20, 20, 10, 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 5.0,
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: new Image(image: AssetImage("assets/images/group.png")),
          ),
        ],
      ),
    );
  }

  aboutSectionView() {
    return Container(
      width: MediaQuery
          .of(bContext)
          .size
          .width,
      padding: EdgeInsets.fromLTRB(20, 20, 25, 10),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text("About me",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.PurpleVColor)),
          SizedBox(
            height: 20,
          ),
          new Text(_formdata["about_me"],
            style: TextStyle(
                fontSize: 14, wordSpacing: 1, color: AppColors.PurpleVColor),
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }

  profileImageSectionView() {
    return Container(
        width: MediaQuery
            .of(bContext)
            .size
            .width,
        margin: EdgeInsets.fromLTRB(20, 5, 25, 10),
        child: ClipRRect(
            borderRadius: new BorderRadius.circular(8.0),
            child: Image.network(
              ProfilePicApi,headers: {"Authorization": "Berear "+UserProfile().getInstance().sg_id}
            )));
  }

  contactsSectionView() {
    return
      new Container(
        color: Colors.lightBlue.shade50,
        padding: EdgeInsets.fromLTRB(20, 5, 25, 10),
        child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Contact info", style: new TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.lightGreen),),
            new Container(
                width: MediaQuery
                    .of(bContext)
                    .size
                    .width,
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 3.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15.0) //
                  ),
                ),
                child:
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.PurpleVColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(_formdata["email"],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.PurpleVColor)),
                          )
                        ])
                  ],
                )),
            new Container(
                width: MediaQuery
                    .of(bContext)
                    .size
                    .width,
                margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
                padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
                decoration: new BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 3.0, color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(15.0)
                  ),
                ),
                child:
                new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Telephone/Mobile",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.PurpleVColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: new MaterialButton(onPressed: ()=>callContactNo(_formdata["contact_no"]),child:getContactNoUI()),
                          )
                        ])
                  ],
                ))
          ],
        ),
      );
  }

  getContactNoUI(){
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Icon(Icons.phone,color: AppColors.PurpleVColor,),
        Text(_formdata["contact_no"],
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.PurpleVColor),),
        SizedBox(width: 10,),
        Text("CALL",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.lightBlueVColor),)

      ],
    );
  }

  void callContactNo(String contactNo){
    launch("tel:$contactNo");
  }

  skillsOrHobbieSectionView(String label,String viewData) {
    return
      new Container(
        color: Colors.lightBlue.shade50,
        padding: EdgeInsets.fromLTRB(20, 5, 25, 10),
        child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(label, style: new TextStyle(fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.lightGreen),),
        new Container(
          width: MediaQuery
              .of(bContext)
              .size
              .width,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          padding: EdgeInsets.fromLTRB(15, 10, 5, 5),
          decoration: new BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 3.0, color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(15.0) //
            ),
          ),
          child:
              new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: SkillOrHobbieView(viewData),
              )
            )
          ],
        ),
      );
  }

  List<Widget> SkillOrHobbieView(String skillOrHobbie) {
    List<Widget> skillRow = new List<Widget>();
    String skills=skillOrHobbie;
    var skill_r = skills.split(",");
    int nbROws= (skill_r.length/3).ceil();
    int skillCount=0;
    Row nContainer;
    for(int i =0; i<nbROws;i++){
      nContainer=
            new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:addSkillsInRow(skillCount,skill_r)
            );
      skillCount = skillCount+3;
      skillRow.add(nContainer);
    }
    return skillRow;
  }

  List<Widget> addSkillsInRow(int skillCount,var skillArray){
    int sCount = skillCount+3>skillArray.length?skillArray.length:skillCount+3;
    List<Widget> rowItems = new List<Widget>();
    for(int i =skillCount; i<sCount;i++){
      rowItems.add(getRowItem(skillArray[i]));
    }
    return rowItems;
  }

  Widget getRowItem(String skill){
    return new Container(
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration: new BoxDecoration(
          color: AppColors.lightPurple,
          border: Border.all(width: 3.0, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(15.0) //
          ),
        ),
      child: new Text(skill==null?"":skill,style: TextStyle(color: Colors.white,fontSize: 11),),
    );

  }

}
