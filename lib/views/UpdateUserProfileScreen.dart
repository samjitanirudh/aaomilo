import 'dart:io';
import 'dart:convert' show utf8, base64;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/image_picker_handler.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Skills.dart';
import 'package:flutter_meetup_login/views/MultiSelectChoiceView.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';


class UpdateUserProfileScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  UpdateUserProfileScreen({Key key, this.title,this.analytics}) : super(key: key);
  final String title;

  @override
  _UpdateProfileState createState() => new _UpdateProfileState(analytics);
}

class _UpdateProfileState extends State<UpdateUserProfileScreen>
    with TickerProviderStateMixin, ImagePickerListener, ProfileUpdateCallbacks {
  final FirebaseAnalytics analytics;
  var _formKey = GlobalKey<FormState>();
  var _formview;
  Map _formdata = new Map();
  File _image;
  AnimationController _controller;
  ImagePickerHandler imagePicker;
  TextStyle style = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white);
  bool isLoading = false;
  List<String> selectedReportList = List();
  List<String> selectCategoryList = List();
  ProfileUpdatePresenter profileUpdatePresenter;
  BuildContext bContext;
  NetworkImage nI;
  var firstNameController = new TextEditingController();
  var aboutController = new TextEditingController();
  var projectController = new TextEditingController();
  var skillController = new TextEditingController();
  var designationController = new TextEditingController();
  var interesetController = new TextEditingController();
  var contactController = new TextEditingController();
  var emailController = new TextEditingController();
  bool loaded=false;
  bool _isLoading=false;
  _UpdateProfileState(this.analytics){
    _formdata["firstname"]="";
    _formdata["about"]="";
    _formdata["_project"]="";
    _formdata["skill"]="";
    _formdata["_designation"]="";
    _formdata["intereset"]="";
  }

  @override
  void initState() {
    super.initState();
    _setCurrentScreen();
    _controller = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    imagePicker = new ImagePickerHandler(this, _controller);
    imagePicker.init();
    profileUpdatePresenter = new ProfileUpdatePresenter(this);
    _isLoading=true;
    profileUpdatePresenter.getProfileData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: "Update Profile Screen",
      screenClassOverride: 'UserProfileScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;

    return new Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.PurpleVColor,
          title: Text("Update Profile"),
          textTheme: TextTheme(
              title: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              )),
        ),
        body:
          new Stack(
            children: <Widget>[
              updateProfileView(context),
              _isLoading?loaderOnViewUpdate():new Container()
            ],
          )
     );
  }

  Widget loaderOnViewUpdate() {
      var modal = new Stack(
        children: [
          new Opacity(
            opacity: 0.3,
            child: const ModalBarrier(dismissible: false, color: AppColors.BackgroundColor),
          ),
          new Center(
            child: new CircularProgressIndicator(),
          ),
        ],
      );
    return modal;
  }

  updateProfileImage(){
    if(loaded && null!=nI){
      return new Container(
        height: 160.0,
        width: 160.0,
        decoration: new BoxDecoration(
          color: const Color(0xff7c94b6),
          image: new DecorationImage(
            image: nI,
            fit: BoxFit.cover,
          ),
          border: Border.all(
              color: Colors.black87, width: 2.0),
          borderRadius: new BorderRadius.all(
              const Radius.circular(80.0)),
        ),
      );
    }else{
      if(_image==null){
        return new Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.topCenter,
                child: new Container(
                  child: new CircleAvatar(
                      radius: 80.0,
                      backgroundColor:
                      const Color(0xFF778899)),
                )),
            new Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(50),
                child: new Image.asset(
                    "assets/images/photo_camera.png")),
          ],
        );
      }else{
        return new Container(
          height: 160.0,
          width: 160.0,
          decoration: new BoxDecoration(
            color: const Color(0xff7c94b6),
            image: new DecorationImage(
              image: new ExactAssetImage(_image.path),
              fit: BoxFit.cover,
            ),
            border: Border.all(
                color: Colors.black87, width: 2.0),
            borderRadius: new BorderRadius.all(
                const Radius.circular(80.0)),
          ),
        );
      }
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';
    else
      return null;
  }

  updateProfileView(BuildContext context){
    return
      _formview = SafeArea(
        child: SingleChildScrollView(
        child: Form(
        key: _formKey,
        child:
            new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                new GestureDetector(
                  onTap: () => imagePicker.showDialog(context),
                  child: new Container(
                    padding: EdgeInsets.all(10),
                    child: updateProfileImage(),
                  ),
                ),
                new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        new TextFormField(
                          autovalidate: true,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Enter Your Full Name",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                          validator: (val) {
                            if (val.length == 0) {
                              return "Please enter your name!";
                            } else {
                              return null;
                            }
                          },
                          onSaved: (String val) {
                            _formdata['firstname'] = val;
                          },
                          controller: firstNameController,
                          keyboardType: TextInputType.emailAddress,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        new TextFormField(
                          validator: (String arg) {
                            if (arg.length < 10)
                              return 'About me must be more than 10 numbers';
                            else
                              return null;
                          },
                          onSaved: (String val) {
                            _formdata['contact_no'] = val;
                          },
                          controller: contactController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Contact no",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        new TextFormField(
                          validator: validateEmail,
                          onSaved: (String val) {
                            _formdata['email'] = val;
                          },
                          controller: emailController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Email",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        new TextFormField(
                          validator: (String arg) {
                            if (arg.length < 10)
                              return 'About me must be more than 10 charaters';
                            else
                              return null;
                          },
                          onSaved: (String val) {
                            _formdata['about'] = val;
                          },
                          controller: aboutController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Write Something about you",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: new TextFormField(
                          validator: (String arg) {
                            if (arg.length < 10)
                              return 'Project information must be more than 10 charaters';
                            else
                              return null;
                          },
                          onSaved: (String val) {
                            _formdata['project'] = val;
                          },
                          controller: projectController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Enter you project name",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
                              borderSide: new BorderSide(),
                            ),
                            //fillColor: Colors.green
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child:
                        new TextFormField(
                          validator: (String arg) {
                            if (arg.length < 10)
                              return 'designation/role must be more than 10 charaters';
                            else
                              return null;
                          },
                          onSaved: (String val) {
                            _formdata['_designation'] = val;
                          },
                          controller: designationController,
                          decoration: new InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(
                                10.0, 20.0, 10.0, 10.0),
                            labelText: "Enter your Designation/Role",
                            fillColor: Colors.white,
                            border: new OutlineInputBorder(
                              borderRadius:
                              new BorderRadius.circular(5.0),
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
                                child:
                                new TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  validator: (String arg) {
                                    if (selectedReportList.length < 1)
                                      return 'Select atleast one skill';
                                    else
                                      return null;
                                  },
                                  onSaved: (String val) {
                                    _formdata['skill'] =
                                        selectedReportList.join(",");
                                  },
                                  controller: skillController,
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    hintText:
                                    selectedReportList.join(" , "),
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(
                                          5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: new Container(
                                  width: 130,
                                  height: 60,
                                  child: new Material(
                                    elevation: 6.0,
                                    borderRadius:
                                    BorderRadius.circular(7.0),
                                    color: AppColors.SecondaryColor,
                                    child: MaterialButton(
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.9,
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 10.0),
                                      onPressed: () {
                                        _showSkillsDialog();
                                      },
                                      child: Text("Select your Skills",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 12)),
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
                                child: new TextFormField(
                                  validator: (String arg) {
                                    if (selectCategoryList.length < 1)
                                      return 'Select atleast one interest ';
                                    else
                                      return null;
                                  },
                                  onSaved: (String val) {
                                    _formdata['intereset'] =
                                        selectCategoryList.join(",");
                                  },
                                  controller: interesetController,
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 3,
                                  decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.all(10),
                                    hintText:
                                    selectCategoryList.join(" , "),
                                    fillColor: Colors.white,
                                    border: new OutlineInputBorder(
                                      borderRadius:
                                      new BorderRadius.circular(
                                          5.0),
                                      borderSide: new BorderSide(),
                                    ),
                                    //fillColor: Colors.green
                                  ),
                                ),
                              )),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: new Container(
                                  width: 130,
                                  height: 60,
                                  child: new Material(
                                    elevation: 6.0,
                                    borderRadius:
                                    BorderRadius.circular(7.0),
                                    color: AppColors.SecondaryColor,
                                    child: MaterialButton(
                                      minWidth: MediaQuery
                                          .of(context)
                                          .size
                                          .width /
                                          2.9,
                                      padding: EdgeInsets.fromLTRB(
                                          10.0, 10.0, 10.0, 10.0),
                                      onPressed: () {
                                        _showInterestDialog();
                                      },
                                      child: Text(
                                          "Select your category of interest",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontSize: 12)),
                                    ),
                                  ))),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.all(40),
                        child: new Material(
                          elevation: 3.0,
                          borderRadius: BorderRadius.circular(7.0),
                          color: AppColors.AcsentVColor,
                          child: MaterialButton(
                            minWidth:
                            MediaQuery
                                .of(context)
                                .size
                                .width / 3.5,
                            padding: EdgeInsets.all(10),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                isLoading = true;

                                _formdata['sgid'] = UserProfile().getInstance().sg_id;

                                if(null!=_image){
                                  var fileExt = basename(_image.path).split(".");
                                  _formdata['profilepicname'] = fileExt[1].toString();
                                }

                                profileUpdatePresenter.PostProfileData(_formdata, _image);
                              }
                            },
                            child: Text("Update",
                                textAlign: TextAlign.center,
                                style: style.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ]),
              ],
            ), decoration: new BoxDecoration(color: Colors.white),
          )
        )
        )
      );
  }

  _showSkillsDialog() {
    showDialog(
        context: bContext,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Skills"),
            content: MultiSelectChip(
              getSkillsData(),
              selectedReportList,
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
        context: bContext,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Select your category of interest"),
            content: MultiSelectChip(
              getCategoryData(),
              selectCategoryList,
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
      loaded=false;
      this._image = _image;
    });
  }

  List<String> getSkillsData() {
    List<String> skilldata = new List<String>();
    List<Skill> skill = SkillClass().getSkillList();
    for (int i = 0; i < skill.length; i++) {
      skilldata.add(skill[i].txtSkill);
    }
    return skilldata;
  }

  List<String> getCategoryData() {
    List<String> categorydata = new List<String>();
    List<Categories> categories = CategoryClass().getCategoryList();
    for (int i = 0; i < categories.length; i++) {
      categorydata.add(categories[i].txtCategoryName);
    }
    return categorydata;
  }

  //Dialog to notify user about invite creation result
  void _showDialog(BuildContext context, String title, String content,bool isError) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                if(isError)
                  closePopup();
                else
                  navigate();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDialogNavigation(BuildContext context, String title, String content,Function fun) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(""),
              onPressed: fun,
            ),
          ],
        );
      },
    );
  }

  navigate() {
    Navigator.of(bContext).pushNamedAndRemoveUntil('/TabViewScreen', (Route<dynamic> route) => false);
  }

  @override
  void showErrorDialog(String errorMesage) {
    if(errorMesage=="sessionExpired") {
      _showDialogNavigation(bContext,"Update profile", errorMesage,tokenExpired());
    }
    else
      _showDialog(bContext,"Update profile", errorMesage,true);
  }

  tokenExpired(){
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }

  @override
  void updatedSuccessfull(String msg) {
    _showDialog(bContext,"Update profile", msg,false);
  }

  closePopup(){
    Navigator.of(bContext).pop();
  }

  @override
  void updateView(Map userdetails) {
    if(mounted) {
      setState(() {
        _isLoading = false;
        if (userdetails.length > 0) {
          firstNameController.text = userdetails["name"];
          emailController.text = userdetails["email"];
          contactController.text = userdetails["contact_no"];
          designationController.text = userdetails["designation"];
          aboutController.text = userdetails["about_me"];
          skillController.text = userdetails["skills"];
          selectedReportList = userdetails["skills"].split(",");
          interesetController.text = userdetails["interest"];
          projectController.text = userdetails["project"];
          selectCategoryList = userdetails["interest"].split(",");
          _formdata["profileimg"] = userdetails["profileimg"];
          if(_formdata["profileimg"]!=""){
            nI = new NetworkImage(_formdata["profileimg"] + "&" +
                new DateTime.now().millisecondsSinceEpoch.toString(),
                headers: {"Authorization": "Berear " + UserProfile()
                    .getInstance()
                    .sg_id});
            nI.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
              if (mounted) {
                setState(() {
                  loaded = true;
                });
              }
            }));
          }else{
                loaded = true;
          }

        }else{
          loaded = true;
        }
      });
    }

  }

}
