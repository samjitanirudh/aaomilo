import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfilePage createState() {
    // TODO: implement createState
    _MyProfilePage _myProfilePage = new _MyProfilePage();
    return _myProfilePage;
  }
}

class _MyProfilePage extends State<MyProfile> implements ProfileUpdateCallbacks{
  TextStyle style =
  TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white,);
  Map _formdata = new Map();
  ProfileUpdatePresenter profileUpdatePresenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formdata["name"]="";
    _formdata["designation"]="";
    _formdata["about_me"]="";
    _formdata["skills"]="";
    _formdata["interest"]="";
    profileUpdatePresenter=new ProfileUpdatePresenter(this);
    profileUpdatePresenter.getProfileData("A6265111");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "My Profile",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                Navigator.of(context).pushNamed('/UpdateUserProfileScreen');
              },
            ),
            new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () {},
            ),
          ],
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          textTheme: TextTheme(
              title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          )),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.pink,
                  height: MediaQuery.of(context).size.height / 2.9,
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/images/profile.png"),
                          minRadius: 60.0,
                          maxRadius: 60.0,
                        ),
                      ),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.all(8),
                              child: new Text(
                                _formdata['name'],
                                style: TextStyle(
                                    fontSize: 24,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ))),
                      Align(
                          alignment: Alignment.center,
                          child: Padding(
                              padding: EdgeInsets.all(2),
                              child: new Text(
                                _formdata['designation'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.normal,
                                    color: Colors.black),
                              ))),
                    ],
                  )),
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
                                  color: Colors.brown),
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
                                  color: Colors.brown),
                            ))),
                  ],
                ),
              ),
              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ButtonTheme(
                      minWidth: 100.0,
                      height: 60.0,
                      child: RaisedButton(
                        child: new Text(_formdata['skills'],
                            style: TextStyle(
                                color: Colors.pink,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        padding: EdgeInsets.all(20),
                        onPressed: null,
                        colorBrightness: Brightness.light,
                        disabledColor: Colors.black12,
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0)),
                      )),
                  ButtonTheme(
                      minWidth: 100.0,
                      height: 60.0,
                      child: RaisedButton(
                          child: new Text("JAVA",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          padding: EdgeInsets.all(20),
                          onPressed: null,
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0)))),
                  ButtonTheme(
                      minWidth: 100.0,
                      height: 60.0,
                      child: RaisedButton(
                          child: new Text("SQL",
                              style: TextStyle(
                                  color: Colors.pink,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          padding: EdgeInsets.all(20),
                          onPressed: null,
                          disabledColor: Colors.black12,
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(30.0))))
                ],
              ),
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
                                color: Colors.brown),
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
        ));
  }

  @override
  void showErrorDialog() {
    // TODO: implement showErrorDialog
  }

  @override
  void updateView(Map userdetails) {
    // TODO: implement updateView
    setState(() {
      _formdata["name"]=userdetails["name"];
      _formdata["designation"]=userdetails["designation"];
      _formdata["about_me"]=userdetails["about_me"];
      _formdata["skills"]=userdetails["skills"];
      _formdata["interest"]=userdetails["interest"];
    });
  }

  @override
  void updatedSuccessfull(String msg) {
    // TODO: implement updatedSuccessfull
  }
}

