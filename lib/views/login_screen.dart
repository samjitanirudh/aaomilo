import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/loginPresenter.dart';

class loginScreen extends StatefulWidget {

  loginScreen({ Key key }) : super(key: key);

  @override
  _loginScreenState createState() => new _loginScreenState();
}

class _loginScreenState extends State<loginScreen> implements LoginCallbacks{
  TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white,);
  var _formKey = GlobalKey<FormState>();
  var _formview;
  bool _isLoading=false;
  String _email;
  String _pwd;
  LoginPresenter _loginPresenter;
  BuildContext bContext;

  _loginScreenState(){
    _loginPresenter= new LoginPresenter(this);
  }

  Widget loginUI(BuildContext context) {
    _formview = Container(
        color: Colors.red,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 50.0),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset(
                          "assets/images/converge.png",
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: 25.0),
                      emailField(),
                      SizedBox(height: 25.0),
                      passwordField(),
                      SizedBox(height: 25.0),
                      _isLoading ? new CircularProgressIndicator() : loginButon(context),
                    ]))));
    return _formview;
  }

  TextFormField emailField() {
    return new TextFormField(
      obscureText: false,
      style: style,
      validator: validateEmail,
      onSaved: (String val) {
        _email = val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          errorStyle: TextStyle(
            color: Colors.white,
            wordSpacing: 5.0,
          ),
          border:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  TextFormField passwordField() {
    return new TextFormField(
        obscureText: true,
        style: style,
        validator: validatePwd,
        onSaved: (String val) {
          _pwd = val;
        },
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Password",
            errorStyle: TextStyle(
              color: Colors.white,
              wordSpacing: 5.0,
            ),
            border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(32.0))));
  }

  Material loginButon(BuildContext context) {
    return new Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(7.0),
      color: Colors.red.shade700,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onPressed: () {
          _login();
        },
        child: Text("LOGIN",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bContext=context;
    return Scaffold(body: Builder(builder: (context) => loginUI(context)));
  }

  void _login(){
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState.save();
//      navigationPage();
      _loginPresenter.loginButtonOnClick(_email, _pwd);
    }
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/SkillSelection');
  }

  void _showToast(BuildContext context,final String message) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: new Text(message),
        action: SnackBarAction(
            label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
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

  String validatePwd(String value) {
    if (value.length==0)
      return 'Enter passwpord';
    else
      return null;
  }

  @override
  void loginSuccessfull() {
    // TODO: implement loginSuccessfull
    _showToast(bContext,"Login successfull");
    setState(() => _isLoading = false);
  }

  @override
  void showLoginError() {
    // TODO: implement showLoginError
    _showToast(bContext,"Login unsuccessfull");
    setState(() => _isLoading = false);
  }

}
