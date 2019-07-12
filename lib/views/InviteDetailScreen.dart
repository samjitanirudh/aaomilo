import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/PhotoScroller.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';

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
  Map _formdata=new Map();
  bool _isLoading = false;
  BuildContext bContext;
  List<String> photoUrls = new List();
  List<String> joinNameList = new List();
  Invite invite;
  String _logentry="",_comment;
  double rating=0.0;
  InviteDetailScreenState(this.invite);

  var joinButtonText = AppStringClass.INV_DTL_JOIN_BUTTON;
  var leaveButtonText = AppStringClass.INV_DTL_LEAVE_BUTTON;
  bool isLeave = false,hideJoinLeaveButton=false,displayStartInviteButton=false;
  bool displayHostLog=false,displayHostLogView=false;
  bool displayCommentRate=false,displayCommentRateView=false;
  InviteListPresenter inviteListPresenter;
  List<Widget> comments;

  @override
  void initState() {
    // `TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(null);
    inviteListPresenter.setInviteDetailCallBack(this);
    comments = userComments();
    updateJoinedUserPhotos();
    displayJoinLeaveButton();
    displayHostLogEditor();
    displayCommentRateEditor();
    displayCommentRateViews();
  }

  int timeRemainingInvite(){
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(invite.created_date+" "+getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    return timeRemaining;
  }

  displayJoinLeaveButton(){
    //user has joined the invite , invite is yet not started, enable leave button
    if (invite.getisJoined() == "1" && invite.inviteStarted=="0" && timeRemainingInvite()>15) isLeave = true;
    //user has not joined the invite , invite is yet not started, enable join button
    if (invite.getisJoined() == "0" && invite.inviteStarted=="0" && timeRemainingInvite()>10) isLeave = false;
    if(invite.getisJoined()== "2" || timeRemainingInvite()<10)
      hideJoinLeaveButton=true;
  }

  displayHostLogEditor(){
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(invite.created_date+" "+getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if(timeRemaining<-60 && invite.getisJoined() == "2" && invite.isLogged=="0"){
      displayHostLog= true;
    }else if(invite.isLogged=="1"){
      displayHostLogView= true;
    }
  }

  displayCommentRateEditor(){
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(invite.created_date+" "+getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if(timeRemaining<-60 && invite.getisJoined() == "1" && invite.isCommented=="0"){
      displayCommentRate= true;
    }
  }

  displayCommentRateViews(){
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(invite.created_date+" "+getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if(timeRemaining<-60  && comments.length>0){
      displayCommentRateView= true;
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
        joinNameList.add(iJoined[i].name);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: AppColors.PrimaryColor,
          title: new Text(AppStringClass.INV_DTL_SCREEN_TITLE),
        ),
        body:
        new Container(
        color: AppColors.BackgroundColor,
          child: new Stack(
            children: <Widget>[
              new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child:
                  Form(
                    key: _formKey,
                    child:new Container(
                      color: AppColors.BackgroundColor,
                      padding: EdgeInsets.all(5),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          inviteDetailHeader(),
                          inviteDetailInfo(),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          inviteJoinedList(),
                          Divider(
                              color: Colors.grey.withOpacity(0.2)
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          new Text(AppStringClass.INV_DTL_DESCRIPTION,
                            style: TextStyle(fontSize: 24),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: new Text(
                              invite.description.toString(),
                              style:
                              TextStyle(fontSize: 18, fontStyle: FontStyle.normal,wordSpacing: 2.2,letterSpacing: 0.2,fontFamily: 'forum'),
                            ),
                          )
                          ,
                          SizedBox(
                            height: 15,
                          ),
                          displayHostLog?hostLogEditor():hostLogView(),
                          displayCommentRateView?commentRateView(comments):new Container(),
                          displayCommentRate?commentRateEditor():new Container(),
                          SizedBox(
                            height: 5,
                          ),
                          hideJoinLeaveButton?new Container():joinOrLeaveInvteButton(),
                        ],
                      ),
                    ),
                  )
              ),
              _isLoading ? loaderOnViewUpdate() : new Container()
            ],
          ),
        )
        );
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
                      AppStringClass.INV_DTL_HOST_BY + invite.first_name.toString(),
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
                      child: Text(AppStringClass.INV_DTL_START_BUTTON),
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
      ),
      new Container(
        width: MediaQuery.of(context).size.width,
        height: 150,
        decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                AppColors.BackgroundColor.withOpacity(0.2),
                AppColors.BackgroundColor,
              ],
              stops: [0.95, 1.0],
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              tileMode: TileMode.repeated,
            )),
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
            height: 120,
            child: PhotoScroller(photoUrls,joinNameList),
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
            color: isLeave ? Colors.red : AppColors.SecondaryColor,
            colorBrightness: Brightness.dark,
            disabledColor: Colors.blueGrey,
            highlightColor: AppColors.AcsentVColor,
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

  hostLogEditor(){
    return new Container(
      child: new Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(AppStringClass.INV_DTL_HOST_LOG,style: TextStyle(fontSize: 20)),
          new TextFormField(
            obscureText: false,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onSaved: (String val) {
              _logentry = val;
              _formdata['_logentry']=_logentry;
            },
            validator: (String arg){
              if(arg.length<10){
                return   AppStringClass.INV_DTL_HOST_LOG_ERR;
              }else
                return null;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: AppStringClass.INV_DTL_HOST_LOG_HINT,
                errorStyle: TextStyle(
                    color: Colors.red,
                    wordSpacing: 1.0,
                    fontSize: 10
                ),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
          new Center(
            child: new FlatButton(
              child: Text(AppStringClass.INV_DTL_SUBMIT_BUTTON),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    _isLoading=true;
                  });
                  inviteListPresenter.hostLog(invite.id, _logentry);
                }
              },
              color: isLeave ? Colors.red : AppColors.SecondaryColor,
              colorBrightness: Brightness.dark,
              disabledColor: Colors.blueGrey,
              highlightColor: AppColors.AcsentVColor,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            ),
          )
        ],
      ),
    );
  }

  hostLogView(){
    if(null!= invite.hostlog && invite.hostlog.toString()!=""){
      return new Container(
        child: new Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:  new NetworkImage(photoUrls[joinNameList.indexOf(invite.first_name)]),
                  radius: 20.0,
                ),
                new Text(invite.first_name,style: TextStyle(fontSize: 20)),
              ],
            )
            ,
            Padding(
              padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
              child: new Text(
                invite.hostlog.toString(),
                style:
                TextStyle(fontSize: 18, fontStyle: FontStyle.normal,wordSpacing: 2.2,letterSpacing: 0.2,fontFamily: 'forum'),
              ),
            )
          ],
        ),
      );
    }else{
      return new Container();
    }

  }

  commentRateView(List<Widget> comments){
    return new Container(
      child: new Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          comments.length>0?new Text(AppStringClass.INV_DTL_USER_CMNTS,style: TextStyle(fontSize: 20)):new Container(),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments,
          )
        ],

      ),
    );
  }

  List<Widget> userComments(){
    List<Widget> usercomments=new List();
    List<InviteJoinees> inviteJoinees =invite.getJoinees();
    for(int i=0;i<inviteJoinees.length;i++)
      {
        InviteJoinees iJ = inviteJoinees[i];
        if(null!=iJ.getComment() && iJ.getComment().toString()!=""){
          Container uComment = new Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(iJ.name.toString()),
                new Text(iJ.getRate().toString()),
                new Text(iJ.getComment().toString()),
              ],
            ),
          );
          usercomments.add(uComment);
        }
      }
    return usercomments;
  }

  commentRateEditor(){
    return new Container(
      child: new Column(
        mainAxisAlignment:MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(AppStringClass.INV_DTL_USER_CMNTS_EDIT,style: TextStyle(fontSize: 20)),
          new TextFormField(
            obscureText: false,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onSaved: (String val) {
              _comment = val;
              _formdata['_comment']=_comment;
            },
            validator: (String arg){
              if(arg.length<10){
                return   AppStringClass.INV_DTL_USER_CMNTS_EDIT_ERR;
              }else
                return null;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: AppStringClass.INV_DTL_USER_CMNTS_EDIT_HINT,
                errorStyle: TextStyle(
                    color: Colors.red,
                    wordSpacing: 1.0,
                    fontSize: 10
                ),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
          new SmoothStarRating(
              allowHalfRating: true,
              onRatingChanged: (v) {
                rating = v;
                setState(() {});
              },
              starCount: 5,
              rating: rating,
              size: 60.0,
              color: Colors.lightBlue.shade800,
              borderColor: Colors.lightBlue.shade800,
              spacing:0.0
          ),
          new Center(
            child: new FlatButton(
              child: Text(AppStringClass.INV_DTL_SUBMIT_BUTTON),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  setState(() {
                    _isLoading=true;
                  });
                  inviteListPresenter.commentAndRate(invite.id, _comment, rating.toString());
                }
              },
              color: isLeave ? Colors.red : AppColors.SecondaryColor,
              colorBrightness: Brightness.dark,
              disabledColor: Colors.blueGrey,
              highlightColor: AppColors.AcsentVColor,
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            ),
          )
        ],

      ),
    );
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
          child: const ModalBarrier(dismissible: false, color: AppColors.BackgroundColor),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
    return modal;
  }
}
