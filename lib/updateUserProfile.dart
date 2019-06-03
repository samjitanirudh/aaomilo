import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateUserProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _UpdateProfileState();
  }
}

class _UpdateProfileState extends State<UpdateUserProfile> {
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    color: Colors.white,
  );

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
                  "Update Profile",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.search),
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
                  height: MediaQuery.of(context).size.height / 3.2,
                  width: MediaQuery.of(context).size.width,
                  child: new Column(
                    verticalDirection: VerticalDirection.down,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new Container(
                          child: CircleAvatar(
                            backgroundImage:
                                AssetImage("assets/images/profile.png"),
                            minRadius: 60.0,
                            maxRadius: 60.0,
                          ),
                        ),
                      ])),
            new Material(
              elevation: 5.0,
              borderRadius: BorderRadius.circular(7.0),
              color: Colors.blue.shade900,
              child: MaterialButton(
                minWidth: MediaQuery.of(context).size.width * 0.8,
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                onPressed: () {
                  navigationPage();
                },
                child: Text("Update Profile",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            )
            ]
                )
            )
        )


    );
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/TabViewScreen');
  }
}
