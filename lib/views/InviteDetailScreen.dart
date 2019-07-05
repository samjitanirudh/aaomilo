import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/PhotoScroller.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';

class InviteDetailScreen extends StatefulWidget {
  final Invite invite;

  InviteDetailScreen({Key key, @required this.invite}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new InviteDetailScreenState(this.invite);
  }
}

class InviteDetailScreenState extends State<StatefulWidget>
    implements InviteDetailCallBack {
  var _formKey = GlobalKey<FormState>();
  var _formView;
  bool _isLoading = false;
  BuildContext bContext;
  List<String> photoUrls = new List();
  Invite invite;

  InviteDetailScreenState(this.invite);

  var joinButtonText = "Attende";
  var leaveButtonText = "Leave";
  bool isLeave = false,hideJoinLeaveButton=false,displayStartInviteButton=false;
  InviteListPresenter inviteListPresenter;


  @override
  void initState() {
    // `TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(null);
    inviteListPresenter.setInviteDetailCallBack(this);
    updateJoinedUserPhotos();
    print(invite.getisJoined());

    if (invite.getisJoined() == "1" && invite.inviteStarted=="0") isLeave = true;
    if (invite.getisJoined() == "0" && invite.inviteStarted=="0") isLeave = false;
    if (invite.getisJoined() == "2" && invite.inviteStarted=="0") {
      hideJoinLeaveButton = true;
      dispplayStartButton();
    }else if (invite.inviteStarted=="1") {
      hideJoinLeaveButton = true;
    }
  }


  dispplayStartButton(){
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(invite.created_date+" "+getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if(timeRemaining>-15 && timeRemaining<30){
      displayStartInviteButton= true;
    }
  }

  getTimeFormated(String time) {
    if (time.toLowerCase().contains("pm")) {
      List<String> tim = time.split(" ")[0].split(":");
      var tHour = int.parse(tim[0]);
      if(int.parse(tim[0])<12)
        tHour = int.parse(tim[0]) + 12;
      return tHour.toString() + ":" + tim[1];
    } else {
      List<String> tim = time.split(" ")[0].split(":");
      var tHour = int.parse(tim[0]);
      if (tHour < 10)
        return "0" + tHour.toString() + ":" + tim[1];
      else
        return tHour.toString() + ":" + tim[1];
    }
  }

  updateJoinedUserPhotos() {
    List<InviteJoinees> iJoined = invite.getJoinees();
    if (iJoined != null && iJoined.length > 0) {
      for (int i = 0; i < iJoined.length; i++) {
        photoUrls.add(iJoined[i].profile_img);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;

    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Invite details'),
        ),
        body: new Stack(
          children: <Widget>[
            new SingleChildScrollView(
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
                    Divider(
                      color: Colors.grey,
                    ),
                    inviteJoinedList(),
                    Divider(
                      color: Colors.grey,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    new Text(
                      "Description",
                      style: TextStyle(fontSize: 24),
                    ),
                    new Text(
                      invite.description.toString(),
                      style:
                          TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    hideJoinLeaveButton?new Container():joinOrLeaveInvteButton(),
                  ],
                ),
              ),
            ),
            _isLoading ? loaderOnViewUpdate() : new Container()
          ],
        ));
  }

  inviteDetailInfo() {
    return new Container(
        padding: EdgeInsets.all(5.0),
        child:
        new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Column(
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
                      invite.created_date.toString() +
                          " " +
                          invite.time.toString() +
                          " onwards",
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
                      "Hosted by " + invite.first_name.toString(),
                      style: new TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            ),
            new SizedBox(width: 10,),
            new Expanded(
                child:
                displayStartInviteButton?new FlatButton(
                      child: Text("START"),
                      onPressed: () {
                        startInvite();
                      },
                      color: Colors.red,
                      colorBrightness: Brightness.dark,
                      disabledColor: Colors.blueGrey,
                      highlightColor: Colors.red,
                      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    ):new Container(),
                  ),
            new SizedBox(width: 10,),

          ],
        )

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
          Image(
            image: AssetImage("assets/images/joined.png"),
            fit: BoxFit.contain,
            width: 32,
            height: 32,
          ),
          SizedBox(
            width: 10,
          ),
          new Text(
            invite.joined.toString() +
                "/" +
                invite.allowed_member_count.toString(),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            width: 5,
          ),
          new Container(
            width: MediaQuery.of(bContext).size.width * 0.7,
            height: 80,
            child: PhotoScroller(photoUrls),
          )
        ],
      ),
    );
  }

  joinOrLeaveInvteButton() {
    return new Container(
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new FlatButton(
            child: Text(isLeave ? leaveButtonText : joinButtonText),
            onPressed: () {
              joinOrLeaveInvite();
            },
            color: isLeave ? Colors.red : Colors.blue,
            colorBrightness: Brightness.dark,
            disabledColor: Colors.blueGrey,
            highlightColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
          )
        ],
      ),
    );
  }

  joinOrLeaveInvite() {
    String doLeave = "join";
    if (isLeave) {
      doLeave = "leave";
    }
    setState(() {
      _isLoading=true;
    });
    inviteListPresenter.joinOrLeave(doLeave, invite.id);
  }


  startInvite() {
    setState(() {
      _isLoading=true;
    });
    inviteListPresenter.startInvite(invite.id);
  }

  @override
  void showError() {
    // TODO: implement showError
  }

  @override
  void showErrorDialog(String error) {
    tokenExpired();
    // TODO: implement showErrorDialog
  }

  tokenExpired() {
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }

  @override
  void updateViewsJoinLeave(String status) {
    // TODO: implement updateViews
    setState(() {
      _isLoading=false;
    });
    navigate();
  }

  @override
  void updateViewsStartInvite(String status) {
    // TODO: implement updateViews
    setState(() {
      _isLoading=false;
    });
    navigate();
  }

  navigate() {
    Navigator.of(bContext).pop(true);
  }

  Widget loaderOnViewUpdate() {
    var modal = new Stack(
      children: [
        new Opacity(
          opacity: 0.3,
          child: const ModalBarrier(dismissible: false, color: Colors.blue),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
    return modal;
  }
}
