import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UpdateProfileState();
  }
}

class _UpdateProfileState extends State<UpdateUserProfile> {

  TextStyle style =
  TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white,);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      backgroundColor: Colors.white,
      body: new Container(
        child: new Center(
          child: new Column(
            // center the children
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Icon(
                Icons.category,
                size: 160.0,
                color: Colors.blue,
              ),
              new Text(
                "First Tab",

                style: new TextStyle(color: Colors.black),
              ),
          new Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(7.0),
            color: Colors.red.shade700,
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
              onPressed: () {
                _login();
              },
              child: Text("Update Profile",
                  textAlign: TextAlign.center,
                  style: style.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
            ],
          ),
        ),
      ),
    );
  }

  void _login(){

      navigationPage();

    }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/TabViewScreen');
  }
  }




