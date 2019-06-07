import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/image_picker_handler.dart';
import 'package:flutter_meetup_login/skillSelection.dart';
import 'package:flutter_meetup_login/views/MultiSelectChoiceView.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  UpdateUserProfileScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _UpdateProfileState createState() => new _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateUserProfileScreen>
    with TickerProviderStateMixin, ImagePickerListener {
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    color: Colors.white,
  );

  List<String> SkillList = [
    "JAVA",
    "ANDROID",
    "SAP",
    "C#",
    "Python",
    "PHP",
    "SQL"
  ];

  List<String> CategoryList = [
    "Technolgy",
    "Fitness",
    "Adventure",
    "Book reading", "Sports","Music","Networking"
      ];

  List<String> selectedReportList = List();
  List<String> selectCategoryList = List();

  @override
  void initState() {
    super.initState();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(
            "Update Profile",
            style: new TextStyle(color: Colors.white),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new GestureDetector(
              onTap: () => imagePicker.showDialog(context),
              child: new Container(
                padding: EdgeInsets.all(10),
                child: _image == null
                    ? new Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topCenter,
                              child: new Container(
                                child: new CircleAvatar(
                                    radius: 80.0,
                                    backgroundColor: const Color(0xFF778899)),
                              )),
                          new Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.all(50),
                              child: new Image.asset(
                                  "assets/images/photo_camera.png")),
                        ],
                      )
                    : new Container(
                        height: 160.0,
                        width: 160.0,
                        decoration: new BoxDecoration(
                          color: const Color(0xff7c94b6),
                          image: new DecorationImage(
                            image: new ExactAssetImage(_image.path),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.black87, width: 2.0),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(80.0)),
                        ),
                      ),
              ),
            ),
            new Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  autovalidate: true,
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    labelText: "Enter Your Full Name",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                  validator: (val) {
                    if (val.length == 0) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: new TextStyle(
                    fontFamily: "Poppins",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    labelText: "Write Something about you",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    labelText: "Enter you project name",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: new TextFormField(
                  decoration: new InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
                    labelText: "Enter your Designation/Role",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(5.0),
                      borderSide: new BorderSide(),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: new Container(
                        width: 180,
//                        height:50,
                        child: new TextFormField(keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: new InputDecoration(
                            contentPadding:
                                EdgeInsets.all(10),
                            hintText: selectedReportList.join(" , "),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: new Container(width: 130, height:60,child: new Material(
                        elevation: 6.0,
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.blue.shade900,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 2.9,
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          onPressed: () {
                            _showSkillsDialog();
                          },
                          child: Text("Select your Skills",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.normal,fontSize: 12)),
                        ),
                      ))),
                ],
              ),

              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: new Container(
                        width: 180,
                        height:50,
                        child: new TextFormField(keyboardType: TextInputType.multiline,
                          maxLines: 4,
                          decoration: new InputDecoration(
                            contentPadding:
                          EdgeInsets.all(10),
                            hintText: selectCategoryList.join(" , "),
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      )),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: new Container(width: 130, height:60,child: new Material(
                        elevation: 6.0,
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.blue.shade900,
                        child: MaterialButton(
                          minWidth: MediaQuery.of(context).size.width / 2.9,
                          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                          onPressed: () {
                            _showInterestDialog();
                          },
                          child: Text("Select your category of interest",
                              textAlign: TextAlign.center,
                              style:
                              TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.normal,fontSize: 12)),
                        ),
                      ))),
                ],
              ),
              Padding(padding: EdgeInsets.all(40),
              child: new Material(
                elevation: 3.0,
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.blue.shade900,
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width / 3.5,
                  padding: EdgeInsets.all(10),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/TabViewScreen');
                  },
                  child: Text("Update Profile",
                      textAlign: TextAlign.center,
                      style: style.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
              ),
            ]),
          ],
        ))));
  }

  _showSkillsDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Skills"),
            content: MultiSelectChip(
              SkillList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectedReportList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Add skills"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  _showInterestDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Select your category of interest"),
            content: MultiSelectChip(
              CategoryList,
              onSelectionChanged: (selectedList) {
                setState(() {
                  selectCategoryList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Add interests"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  @override
  userImage(File _image) {
    setState(() {
      this._image = _image;
    });
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/skillSelection');
  }
}
