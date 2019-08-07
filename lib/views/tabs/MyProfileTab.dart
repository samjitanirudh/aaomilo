import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';

class MyProfile extends StatefulWidget {
  String userid;

  MyProfile({Key key,this.userid}):super(key: key);

  @override
  _MyProfilePage createState() {
    // TODO: implement createState
    _MyProfilePage _myProfilePage = new _MyProfilePage(this.userid);
    return _myProfilePage;
  }
}

class _MyProfilePage extends State<MyProfile> implements ProfileUpdateCallbacks{
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white,);
  Map _formdata = new Map();
  ProfileUpdatePresenter profileUpdatePresenter;
  var _formview;
  bool _isLoading = false;
  BuildContext bContext;
  String user_id;
  String ProfilePicApi=AppStringClass.APP_BASE_URL+"work/action.php?action=profilepic";
  _MyProfilePage(this.user_id);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileUpdatePresenter=new ProfileUpdatePresenter(this);

    if(UserProfile().getInstance().first_name=="" || user_id!=""){
      getUserProfileData(user_id);
    }else{
      loadViewWithData(UserProfile().getInstance().getUserDataInMap(UserProfile().getInstance()));
    }
  }

  getUserProfileData(String user_id){
    _formdata["name"]="";
    _formdata["designation"]="";
    _formdata["about_me"]="";
    _formdata["skills"]="";
    _formdata["interest"]="";
    _formdata["email"]="";
    _formdata["contact_no"]="";
    _isLoading=true;
    if(user_id=="" || user_id==null)
      profileUpdatePresenter.getProfileData();
    else
      profileUpdatePresenter.getUserProfileData(user_id);
  }

  @override
  Widget build(BuildContext context) {
    bContext=context;
    bool loaded=false;
    NetworkImage nI;
    String imgUrl="";
    if(user_id!=""){
      imgUrl= ProfilePicApi+"&user_id="+user_id;
    }else if(null!=_formdata["profileimg"]) {
      imgUrl= ProfilePicApi;
    }
    nI = new NetworkImage(imgUrl,headers: {"Authorization": "Berear "+UserProfile().getInstance().sg_id});
    nI.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          loaded = true;
        });
      }
    }));

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.PrimaryColor,
          title: Text("My Profile"),
          actions: user_id==""?<Widget>[new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed('/UpdateUserProfileScreen');
              },
            ), new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {
                tokenExpired();
              },
            ),]:<Widget>[],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          )),
        ),
        body: new Stack(
        children: getProfileView(loaded,nI)
      ));

  }

  tokenExpired() {
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }

  List<Widget> getProfileView(bool loaded,NetworkImage nI){
    _formview=SafeArea(
      child: SingleChildScrollView(
          child: new Container(
            height: MediaQuery.of(bContext).size.height,
              decoration: new BoxDecoration(color: AppColors.BackgroundColor),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child:
                    new Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            new Container(
                                width: 120.0,
                                height: 120.0,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: loaded ? nI : AssetImage(
                                          "assets/images/profile.png")
                                  ),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(8.0)),
                                  color: Colors.redAccent,
                                )),
                          ],
                        ),
                        Expanded(
                            child:
                            new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(padding: EdgeInsets.all(8.0),
                                      child: new Text(
                                        _formdata['name'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      )),
                                ),
                                SizedBox(height: 5,),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(padding: EdgeInsets.all(8.0),
                                        child: new Text(
                                          _formdata['designation'],
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black),
                                        ))),
                                SizedBox(height: 5,),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(padding: EdgeInsets.all(8.0),
                                        child: new Text(
                                          _formdata['email'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black),
                                        ))),
                                SizedBox(height: 5,),
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(padding: EdgeInsets.all(8.0),
                                        child: new Text(
                                          _formdata['contact_no'],
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontStyle: FontStyle.normal,
                                              color: Colors.black),
                                        )))
                              ],
                            )
                        )],
                    )
                ),
                Container(
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: new Text(
                                "About Me",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.AcsentVColor),
                              ))),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: new Text(_formdata['about_me'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              ))),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                              padding: EdgeInsets.all(12),
                              child: new Text(
                                "My Skills",
                                style: TextStyle(
                                    fontSize: 22,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.AcsentVColor),
                              ))),
                    ],
                  ),
                ),
                new Container(
                    height: 60.0,
                    child: new Scrollbar(child: new ListView(
                        scrollDirection: Axis.horizontal,
                        children:getUserSkillsView()
                    ))
                ),
//              ),
                Container(
                  child: new Column(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: EdgeInsets.all(12),
                                child: new Text(
                                  "My Interests",
                                  style: TextStyle(
                                      fontSize: 22,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.AcsentVColor),
                                ))),
                        Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                                padding: EdgeInsets.all(12),
                                child: new Text(_formdata['interest'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.normal,
                                      color: Colors.black),
                                ))),
                      ]
                  ),
                )
              ],
            )),
          )
    );
    var view =new List<Widget> () ;
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

  List<ButtonTheme> getUserSkillsView(){
    List<String> skills = _formdata["skills"].toString().split(",");
    return new List.generate(skills.length, (int index){
      return ButtonTheme(
          minWidth: 100.0,
          height: 60.0,
          child: RaisedButton(
              child: new Text(skills[index],
                  style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              padding: EdgeInsets.all(20),
              onPressed: null,
              disabledColor: Colors.black12,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0))));
    });
  }

  @override
  void showErrorDialog(String errorMesage) {
    if(errorMesage=="sessionExpired") {
      UserProfile().getInstance().resetUserProfile(); //
      Navigator.of(context).pushReplacementNamed('/Loginscreen');
    }
    else
      ;//_showDialog(bContext,"View profile", errorMesage,true);
  }

  @override
  void updateView(Map userdetails) {
    // TODO: implement updateView
    if(mounted) {
      setState(() {
        if(userdetails.length>0){
          loadViewWithData(userdetails);
        }
        _isLoading=false;
      });
    }
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
  }

  @override
  void updatedSuccessfull(String msg) {
    // TODO: implement updatedSuccessfull
  }
}

