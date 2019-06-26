import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/utils/PhotoScroller.dart';

class InviteDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new InviteDetailScreenState();
  }
}

class InviteDetailScreenState extends State<StatefulWidget> {
  var _formKey = GlobalKey<FormState>();
  var _formView;
  bool _isLoading = false;
  BuildContext bContext;
  List<String> photoUrls= new List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    photoUrls.add("https://i.pinimg.com/564x/1d/d9/c1/1dd9c1044a74ba33e840456b7c705192.jpg");
    photoUrls.add("https://i.pinimg.com/564x/1d/d9/c1/1dd9c1044a74ba33e840456b7c705192.jpg");
    photoUrls.add("https://i.pinimg.com/564x/1d/d9/c1/1dd9c1044a74ba33e840456b7c705192.jpg");
    photoUrls.add("https://i.pinimg.com/564x/1d/d9/c1/1dd9c1044a74ba33e840456b7c705192.jpg");
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;


    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Invite details'),
        ),
        body: new SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: new Container(
            color: Colors.blue.shade100,
            padding: EdgeInsets.all(5),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                inviteDetailHeader(),
                Divider(
                  color: Colors.grey,
                ),
                inviteDetailInfo(),
                Divider(color: Colors.grey,),
                inviteJoinedList(),
                Divider(color: Colors.grey,),
              ],
            ),
          ),
        ));
  }

  inviteDetailInfo() {
    return new Container(
      padding: EdgeInsets.all(5.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            "Invitation for Flutter UI",
            style: new TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          new Row(
            children: <Widget>[
              new Icon(Icons.timer),
              SizedBox(
                width: 10,
              ),
              new Text(
                "28 June 2019 06pm onwards",
                style: new TextStyle(fontSize: 12),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Icon(Icons.place),
              SizedBox(
                width: 10,
              ),
              new Text(
                "Time square, ground floor, common area",
                style: new TextStyle(fontSize: 12),
              )
            ],
          ),
          new Row(
            children: <Widget>[
              new Icon(Icons.person),
              SizedBox(
                width: 10,
              ),
              new Text(
                "Hosted by Monika J",
                style: new TextStyle(fontSize: 12),
              )
            ],
          )
        ],
      ),
    );
  }

  inviteDetailHeader() {
    return new Stack(alignment: Alignment.bottomRight, children: <Widget>[
      new Container(
          height: MediaQuery.of(bContext).size.height * 0.25,
          width: MediaQuery.of(bContext).size.width,
          child: Image(
            image: new AssetImage('assets/images/splash_screen.png'),
            fit: BoxFit.fill,
          )),
      new Container(
        height: 32,
        margin: EdgeInsets.all(5),
        width: MediaQuery.of(bContext).size.width,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new MaterialButton(
                onPressed: null,
                child:
                    Image(image: AssetImage("assets/images/favourites.png"))),
            new MaterialButton(
                onPressed: null,
                child: Image(image: AssetImage("assets/images/profile.png"))),
            new MaterialButton(
                onPressed: null,
                child: Image(image: AssetImage("assets/images/comment.png"))),
          ],
        ),
      )
    ]);
  }

  inviteJoinedList() {
    return new Container(
      padding: EdgeInsets.all(5.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Image(image: AssetImage("assets/images/joined.png"),fit: BoxFit.contain,width: 32,height: 32,),
           SizedBox(width: 10,),
          new Text("0/5",style: TextStyle(fontSize: 18),),
          SizedBox(width: 5,),
          new Container(
            width: MediaQuery.of(bContext).size.width*0.7,
            height: 80,
            child: PhotoScroller(photoUrls),)

        ],
      ),
    );
  }
}
