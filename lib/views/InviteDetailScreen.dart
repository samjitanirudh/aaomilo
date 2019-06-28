import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/utils/PhotoScroller.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';

class InviteDetailScreen extends StatefulWidget {
  final Invite invite;

  InviteDetailScreen({Key key,@required this.invite}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new InviteDetailScreenState(this.invite);
  }
}

class InviteDetailScreenState extends State<StatefulWidget> {
  var _formKey = GlobalKey<FormState>();
  var _formView;
  bool _isLoading = false;
  BuildContext bContext;
  List<String> photoUrls= new List();
  Invite invite;
  InviteDetailScreenState(this.invite);
  var joinButtonText="Join Invite";
  var leaveButtonText="Leave Invite";
  bool isLeave=false;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateJoinedUserPhotos();
    print("flag"+invite.getisJoined().toString());
    isLeave=invite.getisJoined();
  }

  updateJoinedUserPhotos(){
    List<InviteJoinees> iJoined=invite.getJoinees();
    for(int i=0;i<iJoined.length;i++){
      print(iJoined[i].profile_img);
      photoUrls.add(iJoined[i].profile_img);
    }
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(height: 5,),
                new Text("Description",style: TextStyle(fontSize: 24),),
                new Text(invite.description.toString(),style: TextStyle(fontSize: 20,fontStyle:FontStyle.italic ),),
                SizedBox(height: 5,),
                joinOrLeaveInvteButton()
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
            invite.title.toString(),
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
                invite.created_date.toString()+" "+invite.time.toString()+" onwards",
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
                invite.venue.toString(),
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
                "Hosted by "+invite.first_name.toString(),
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
            image: NetworkImage(invite.image.toString()),
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
          new Text(invite.joined.toString()+"/"+invite.allowed_member_count.toString(),style: TextStyle(fontSize: 18),),
          SizedBox(width: 5,),
          new Container(
            width: MediaQuery.of(bContext).size.width*0.7,
            height: 80,
            child: PhotoScroller(photoUrls),)
        ],
      ),
    );
  }

  joinOrLeaveInvteButton(){
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new FlatButton(
            child: Text(isLeave?leaveButtonText:joinButtonText),
            onPressed: () {

            },
            color: Colors.blue,
            colorBrightness: Brightness.dark,
            disabledColor: Colors.blueGrey,
            highlightColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          )
        ],
      ),
    );
  }
}
