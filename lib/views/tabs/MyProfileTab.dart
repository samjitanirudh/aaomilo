import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/ProfileUpdatePresenter.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

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
  var _formview;
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formdata["name"]="";
    _formdata["designation"]="";
    _formdata["about_me"]="";
    _formdata["skills"]="";
    _formdata["interest"]="";
    _formdata["email"]="";
    _formdata["contact_no"]="";
    profileUpdatePresenter=new ProfileUpdatePresenter(this);
    _isLoading=true;
    profileUpdatePresenter.getProfileData();

  }

  @override
  Widget build(BuildContext context) {
    bool loaded=false;
    NetworkImage nI;
    if(null!=_formdata["profileimg"]) {
      print("Berear "+UserProfile().getInstance().sg_id);
      nI = new NetworkImage(_formdata["profileimg"],headers: {"Authorization": "Berear "+UserProfile().getInstance().sg_id});
      nI.resolve(new ImageConfiguration()).addListener((_, __) {
        if (mounted) {
          setState(() {
            _isLoading=false;
            loaded = true;
          });
        }
      });
    }
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text("My Profile"),
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
        body: new Stack(
        children: getProfileView(loaded,nI)
      ));

  }

  List<Widget> getProfileView(bool loaded,NetworkImage nI){
    _formview=SafeArea(
      child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.blue.shade100,
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
                      color: Colors.pink,
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
        _formdata["name"] = userdetails["name"];
        _formdata["designation"] = userdetails["designation"];
        _formdata["about_me"] = userdetails["about_me"];
        _formdata["skills"] = userdetails["skills"];
        _formdata["interest"] = userdetails["interest"];
        _formdata["profileimg"] = userdetails["profileimg"]+"&"+new DateTime.now().millisecondsSinceEpoch.toString();
        _formdata["email"]= userdetails["email"];
        _formdata["contact_no"]= userdetails["contact_no"];
        _formdata["project"]= userdetails["project"];

      });
    }
  }

  @override
  void updatedSuccessfull(String msg) {
    // TODO: implement updatedSuccessfull
  }
}

