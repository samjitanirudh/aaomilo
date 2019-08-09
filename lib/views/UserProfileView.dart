import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';

class UserProfileView extends StatefulWidget {
  String userid;

  UserProfileView({Key key, this.userid}) : super(key: key);

  @override
  UserProfileViewState createState() {
    // TODO: implement createState
    UserProfileViewState _myProfilePage = new UserProfileViewState(this.userid);
    return _myProfilePage;
  }
}

class UserProfileViewState extends State<UserProfileView>
    implements ProfileUpdateCallbacks {
  String userid;

  UserProfileViewState(this.userid);

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

//    if(UserProfile().getInstance().first_name=="" || user_id!=""){
    if (false) {
      getUserProfileData(user_id);
    } else {
//      loadViewWithData(UserProfile().getInstance().getUserDataInMap(UserProfile().getInstance()));
      loadViewWithData();
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
    _isLoading = true;
    if (user_id == "" || user_id == null)
      profileUpdatePresenter.getProfileData();
    else
      profileUpdatePresenter.getUserProfileData(user_id);
  }

//  loadViewWithData(Map userdetails){
  loadViewWithData() {
    _formdata["name"] = "Anirudh Tandel";
    _formdata["designation"] = "Team Lead";
    _formdata["about_me"] =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";
    _formdata["skills"] = "Android, PHP, JAVA, iOS, Cross Platform";
    _formdata["interest"] = "Travel, Music, Movies, Reading";
    _formdata["profileimg"] = ProfilePicApi;
    _formdata["email"] = "anirudh.tandel@saint-gobain.com";
    _formdata["contact_no"] = "8879229975";
    _formdata["project"] = "SGDBF - Mobile Applications";
    UserProfile().getInstance().setProfileImageUpdate(false);
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
//          loadViewWithData(userdetails);
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
    // TODO: implement build
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.PurpleVColor,
          title: Text("Profile"),
          actions: user_id == ""
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
                skillsSectionView()
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
          new Text(
            "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete ",
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
              ProfilePicApi + "&user_id=A6265111",
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
                            child: Text("anirudh.tandel@saint-gobain.com",
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
                              "Telephone/Mobile",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.PurpleVColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("8879229975",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.PurpleVColor)),
                          )
                        ])
                  ],
                ))
          ],
        ),
      );
  }

  skillsSectionView() {
    return
      new Container(
        color: Colors.lightBlue.shade50,
        padding: EdgeInsets.fromLTRB(20, 5, 25, 10),
        child:
        new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text("Skills", style: new TextStyle(fontSize: 20,
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
                            child: Text("anirudh.tandel@saint-gobain.com",
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
                              "Telephone/Mobile",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.PurpleVColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text("8879229975",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.PurpleVColor)),
                          )
                        ])
                  ],
                ))
          ],
        ),
      );
  }
}
