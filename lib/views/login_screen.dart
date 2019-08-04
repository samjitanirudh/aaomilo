import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/loginPresenter.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'dart:convert';

import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';

class loginScreen extends StatefulWidget {
  final FirebaseAnalytics analytics;
  loginScreen({Key key,this.analytics}) : super(key: key);

  @override
  _loginScreenState createState() => new _loginScreenState(analytics);
}

class _loginScreenState extends State<loginScreen> implements LoginCallbacks {
  final FirebaseAnalytics analytics;
  String _accessToken = 'LOGIN';
    TextStyle style = TextStyle(
		fontFamily: 'Montserrat',
		fontSize: 20.0,
		color: Colors.white,
    );
  var _formKey = GlobalKey<FormState>();
  var _formview;
  bool _isLoading = false;
  String _email;
  TextEditingController _emailController = new TextEditingController();
  String _pwd;
  TextEditingController _pwdController = new TextEditingController();
  LoginPresenter _loginPresenter;
  BuildContext bContext;

  _loginScreenState(this.analytics) {
    _loginPresenter = new LoginPresenter(this);
  }

  List<Widget> loginUI(BuildContext context) {
    _formview = Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
        decoration: new BoxDecoration(
//          color: Colors.blue.shade50,
            image: new DecorationImage(
                image: new AssetImage("assets/images/loginbgb.jpg"),
                fit: BoxFit.cover)),
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 50.0, width: 50.0,),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        width:  MediaQuery.of(context).size.width,
                        child: Image.asset(
                          "assets/images/logoConverge.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      new Theme(
                          data: new ThemeData(
                              hintColor: Colors.blue.shade100
                          ),
                          child:
                          emailField(),
                      ),
                      SizedBox(height: 25.0),
                      new Theme(
                          data: new ThemeData(
                              hintColor: Colors.blue.shade100
                          ),
                          child:
                            passwordField()
                      ),
                      SizedBox(height: 25.0),
//                      _isLoading
//                          ? new CircularProgressIndicator()
//                          :
                      loginButon(context),
                    ]))));
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

  TextFormField emailField() {
    return new TextFormField(
      controller: _emailController,
      obscureText: false,
      style: style,
      validator: validateEmail,
      onSaved: (String val) {
        _email = _emailController.text;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "SGID",
          hintStyle: TextStyle(color: Colors.white),
          errorStyle: TextStyle(
            color: Colors.white,
            wordSpacing: 5.0,
          ),
          border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.white))),
    );
  }

  TextFormField passwordField() {
    return new TextFormField(
        controller: _pwdController,
        obscureText: true,
        style: style,
        validator: validatePwd,
        onSaved: (String val) {
          _pwd = _pwdController.text;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.white),
            errorStyle: TextStyle(
              color: Colors.white,
              wordSpacing: 5.0,
            ),
//            border: new OutlineInputBorder(borderSide: new BorderSide(color: Colors.white))
            border: new OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)),borderSide: new BorderSide(color: Colors.pink))
        ));
  }

  Material loginButon(BuildContext context) {
    return new Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(7.0),
      color: Colors.blue.shade600,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onPressed: () {
          _login();
        },
        child: Text(_accessToken,
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setCurrentScreen();
  }

  Future<void> _setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: "Login Screen",
      screenClassOverride: 'LoginScreen',
    );
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return new Scaffold(
      body: new Stack(
        children: loginUI(context),
      ),
    );
  }
  void _login() {
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      _loginPresenter.loginButtonOnClick(_emailController.text, _pwdController.text);
//      _formKey.currentState.save();
//      navigationPage();

//      _loginPresenter.loginButtonOnClick(_email, _pwd);
    }
  }


  void navigationPage(String user) {
    UserProfile().getInstance().saveLoggedInUser(user);   //replace SGID with logged in user
    Navigator.of(context).pushReplacementNamed('/TabViewScreen');
  }

  String validateEmail(String value) {
//    Pattern pattern =
//        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
//    RegExp regex = new RegExp(pattern);
//    if (!regex.hasMatch(value))
      if (value.length == 0)
      return 'Enter Valid Email';
    else
      return null;
  }

  String validatePwd(String value) {
    if (value.length == 0)
      return 'Enter passwpord';
    else
      return null;
  }

  @override
  void loginSuccessfull(String response) {
    // TODO: implement loginSuccessfull
    // _showToast(bContext, "Login successfull");
    if(response!=null || response.compareTo("")!=0)
        setState(() => _isLoading = false);
        Map sessionList=json.decode(response);
        navigationPage(sessionList["access_token"].toString());
  }

  @override
  void showLoginError(String error_response) {
    // TODO: implement showLoginError
    setState(() => _isLoading = false);
    _showDialog(bContext,"Please check SGID and password and try again later");
  }
  //Dialog to notify user about invite creation result
  void _showDialog(BuildContext context,String content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Error"),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                Navigator.of(bContext).pop();
              },
            ),
          ],
        );
      },
    );
  }


}
