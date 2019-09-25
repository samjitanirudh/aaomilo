import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/PhotoScroller.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';
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
  Map _formdata = new Map();
  bool _isLoading = false;
  BuildContext bContext;
  List<String> photoUrls = new List();
  List<String> joinNameList = new List();
  List<String> joinUserList = new List();
  Invite invite;
  String _logentry = "", _comment;
  double rating = 0.0;

  InviteDetailScreenState(this.invite);

  var joinButtonText = AppStringClass.INV_DTL_JOIN_BUTTON;
  var leaveButtonText = AppStringClass.INV_DTL_LEAVE_BUTTON;
  bool isLeave = false,
      hideJoinLeaveButton = false,
      displayStartInviteButton = false;
  bool displayHostLog = false, displayHostLogView = false;
  bool displayCommentRate = false, displayCommentRateView = false;
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

  int timeRemainingInvite() {
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(
        invite.created_date + " " + getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    return timeRemaining;
  }

  displayJoinLeaveButton() {
    //user has joined the invite , invite is yet not started, enable leave button
    if (invite.getisJoined() == "1" &&
        invite.inviteStarted == "0" &&
        timeRemainingInvite() > 15) isLeave = true;
    //user has not joined the invite , invite is yet not started, enable join button
    if (invite.getisJoined() == "0" &&
        invite.inviteStarted == "0" &&
        timeRemainingInvite() > 10) isLeave = false;
    if (invite.getisJoined() == "2" || timeRemainingInvite() < 10)
      hideJoinLeaveButton = true;
  }

  displayHostLogEditor() {
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(
        invite.created_date + " " + getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if (timeRemaining < -60 &&
        invite.getisJoined() == "2" &&
        invite.isLogged == "0") {
      displayHostLog = true;
    } else if (invite.isLogged == "1") {
      displayHostLogView = true;
    }
  }

  displayCommentRateEditor() {
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(
        invite.created_date + " " + getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if (timeRemaining < -60 &&
        invite.getisJoined() == "1" &&
        invite.isCommented == "0") {
      displayCommentRate = true;
    }
  }

  displayCommentRateViews() {
    var now = new DateTime.now();
    var inviteDate = DateTime.parse(
        invite.created_date + " " + getTimeFormated(invite.time));
    int timeRemaining = inviteDate.difference(now).inMinutes;
    if (timeRemaining < -60 && comments.length > 0) {
      displayCommentRateView = true;
    }
  }

  getTimeFormated(String time) {
    if (time.toLowerCase().contains("pm")) {
      List<String> tim = time.split(" ")[0].split(":");
      var tHour = int.parse(tim[0]);
      if (int.parse(tim[0]) < 12) tHour = int.parse(tim[0]) + 12;
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
        joinUserList.add(iJoined[i].sg_id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: AppColors.PurpleVColor,
          title: new Text(
            invite.title.toString(),
            style: TextStyle(fontSize: 15),
          ),
        ),
        body: new Container(
          color: Colors.white,
          child: new Stack(
            children: <Widget>[
              new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: new Container(
                      color: Colors.white,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          inviteDetailHeader(),
                          inviteDescriptionView(),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          invitejonees(),
                          Divider(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          new Container(
                            padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                            child:
                              new Text("Feedback on invite",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.lightGreen),
                              )
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          displayHostLog ? hostLogEditor() : hostLogView(),
                          displayCommentRateView
                              ? commentRateView(comments)
                              : new Container(),
                          displayCommentRate
                              ?Padding(
                            padding: EdgeInsets.all(10),
                            child: new Material(
                              elevation: 3.0,
                              borderRadius: BorderRadius.circular(7.0),
                              color: AppColors.lightBlueVColor,
                              child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  MaterialButton(
                                    padding:
                                        EdgeInsets.only(right: 5, left: 15),
                                    onPressed: () {
                                      commentRateEditor_dialog();
                                    },
                                    child: Text("Put your review",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 20.0,
                                            color: Colors.white)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(right: 15),
                                    child: new Icon(
                                      Icons.rate_review,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                              : new Container(),
                        ],
                      ),
                    ),
                  )),
              _isLoading ? loaderOnViewUpdate() : new Container()
            ],
          ),
        ));
  }

  inviteDescriptionView() {
    return new Container(
      padding: EdgeInsets.all(15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              new Text(
                "Description",
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    wordSpacing: 2.2,
                    letterSpacing: 0.2,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          Divider(
            height: 15,
            color: AppColors.BackgroundColor,
          ),
          Padding(
            padding: EdgeInsets.all(0),
            child: new Text(
              "I think it’s important to know that you don’t have to learn to code or take on what we refer to as a technical role. While I think that with enough dedication anyone can learn how to code, or be an engineer, you might just not want to.There are so many other roles to consider in tech. I’ll give you my thoughts on some of them and I’ll explore how viable they are from the point of view of someone in Naija.",
              style: TextStyle(
                  fontSize: 19,
                  fontStyle: FontStyle.normal,
                  wordSpacing: 1.2,
                  letterSpacing: 0.1,
                  fontFamily: 'forum'),
              textAlign: TextAlign.justify,
            ),
          )
        ],
      ),
    );
  }

  inviteDetailInfo() {
    return new Container(
        padding: EdgeInsets.all(5.0),
        child: new Row(
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
                      AppStringClass.INV_DTL_HOST_BY +
                          invite.first_name.toString(),
                      style: new TextStyle(fontSize: 12),
                    )
                  ],
                )
              ],
            ),
            new SizedBox(
              width: 10,
            ),
            new Expanded(
              child: displayStartInviteButton
                  ? new FlatButton(
                      child: Text(AppStringClass.INV_DTL_START_BUTTON),
                      onPressed: () {
                        startInvite();
                      },
                      color: Colors.red,
                      colorBrightness: Brightness.dark,
                      disabledColor: Colors.blueGrey,
                      highlightColor: Colors.red,
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                    )
                  : new Container(),
            ),
            new SizedBox(
              width: 10,
            ),
          ],
        ));
  }

  inviteDetailHeader() {
    return new Stack(alignment: Alignment.bottomRight, children: <Widget>[
      new Container(
        padding: EdgeInsets.all(10),
        decoration: new BoxDecoration(color: AppColors.PurpleVColor),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 3.0, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              child: new Column(
                children: <Widget>[
                  new Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: AppColors.BackgroundColor,
                        backgroundImage: NetworkImage(
                            "https://cdn1.iconfinder.com/data/icons/clock-faces-1-12/100/Clock-8-128.png"),
                        radius: 20.0,
                      ),
                      Expanded(
                          child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: new Text("Date & Time"),
                              )
                            ],
                          ),
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                  child:
                                      new Text(invite.created_date.toString())),
                              new Container(
                                  padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                  child: new Text(
                                      invite.time.toString() + " onwards"))
                            ],
                          )
                        ],
                      ))
                    ],
                  ),
                  Divider(
                    height: 20,
                    color: AppColors.SecondaryColor,
                  ),
                  new Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: AppColors.BackgroundColor,
                        backgroundImage: NetworkImage(
                            "https://www.shareicon.net/data/256x256/2015/11/22/676270_map_512x512.png"),
                        radius: 20.0,
                      ),
                      Expanded(
                          child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Row(
                            children: <Widget>[
                              new Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                                child: new Text("Location"),
                              )
                            ],
                          ),
                          new Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
                              child: new Text(invite.venue.toString()))
                        ],
                      ))
                    ],
                  )
                ],
              ),
            ),
            //hideJoinLeaveButton?new Container():joinOrLeaveInvteButton(),
            hideJoinLeaveButton
                ? new Container()
                : new Container(
                    margin: EdgeInsets.all(5),
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    decoration: BoxDecoration(
                      color: isLeave ? Colors.red : AppColors.lightBlueVColor,
                      border: Border.all(
                          width: 3.0,
                          color:
                              isLeave ? Colors.red : AppColors.lightBlueVColor),
                      borderRadius: BorderRadius.all(Radius.circular(5.0) //
                          ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        joinOrLeaveInvteButton(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding:
                                  EdgeInsets.only(left: 5, right: 15, top: 5),
                              child: Text(
                                isLeave ? "" : "+",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 25),
                              ),
                            )
                          ],
                        )
                      ],
                    ))
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
            height: 120,
            child: PhotoScroller(photoUrls, joinNameList, joinUserList),
          )
        ],
      ),
    );
  }

  invitejonees() {
    var labelText_completed = "Invite Participants";
    var labelText_pending = "Open slots(" + invite.joined.toString() + "/" +invite.allowed_member_count.toString() +")";
    var labelCondition=false;
    if(displayCommentRate || displayCommentRateView){
      labelCondition=true;
    }
    if(displayHostLog || displayHostLogView){
      labelCondition=true;
    }
    return Container(
      padding: EdgeInsets.all(15),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Container(
            child: Text(
              labelCondition?labelText_completed:labelText_pending,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.lightGreen),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          new Container(
            child: PhotoScroller(photoUrls, joinNameList, joinUserList),
          )
        ],
      ),
    );
  }

  joinOrLeaveInvteButton() {
    return new Container(
      width: MediaQuery.of(bContext).size.width * 0.8,
      padding: EdgeInsets.only(left: 5, right: 5, top: 5),
      child: new FlatButton(
        child: Text(isLeave ? leaveButtonText : joinButtonText),
        onPressed: () {
          joinOrLeaveInvite();
        },
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(5.0),
        ),
        colorBrightness: Brightness.dark,
        disabledColor: Colors.blueGrey,
        highlightColor: AppColors.AcsentVColor,
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      ),
    );
  }

  joinOrLeaveInvite() {
    String doLeave = "join";
    if (isLeave) {
      doLeave = "leave";
    }
    setState(() {
      _isLoading = true;
    });
    inviteListPresenter.joinOrLeave(doLeave, invite.id);
  }

  startInvite() {
    setState(() {
      _isLoading = true;
    });
    inviteListPresenter.startInvite(invite.id);
  }

  hostLogEditor() {
    double sizeWidth = MediaQuery.of(bContext).size.width;
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            width: sizeWidth * 0.85,
            padding: EdgeInsets.all(5),
            decoration: new BoxDecoration(
              color: AppColors.BackgroundColor,
              border: Border.all(width: 3.0, color: Colors.white),
              borderRadius: BorderRadius.all(Radius.circular(15.0) //
                  ),
            ),
            child: new TextFormField(
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: 2,
              onSaved: (String val) {
                _logentry = val;
                _formdata['_logentry'] = _logentry;
              },
              validator: (String arg) {
                if (arg.length < 10) {
                  return AppStringClass.INV_DTL_HOST_LOG_ERR;
                } else
                  return null;
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: AppStringClass.INV_DTL_HOST_LOG_HINT,
                  errorStyle: TextStyle(
                      color: Colors.red, wordSpacing: 1.0, fontSize: 10),
                  border: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0))),
            ),
          ),
          new ClipOval(
            child: Material(
              color: Colors.orange.shade300, // button color
              child: InkWell(
                splashColor: AppColors.PrimaryColor, // inkwell color
                child: SizedBox(
                    width: sizeWidth * 0.15,
                    height: 48,
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    )),
                onTap: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      _isLoading = true;
                    });
                    inviteListPresenter.hostLog(invite.id, _logentry);
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  hostLogView() {
    if (null != invite.hostlog && invite.hostlog.toString() != "") {
      return new Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: new NetworkImage(
                      photoUrls[joinNameList.indexOf(invite.first_name)]),
                  radius: 20.0,
                ),
                new Text(invite.first_name, style: TextStyle(fontSize: 20)),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 15, 5, 15),
              child: new Text(
                invite.hostlog.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.normal,
                    wordSpacing: 2.2,
                    letterSpacing: 0.2,
                    fontFamily: 'forum'),
              ),
            )
          ],
        ),
      );
    } else {
      return new Container();
    }
  }

  feedbackView(){
    return new Container(
        child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          ]
        )
    );
  }

  feedBackViewChild(String nameOfCommenter){
    return new Container(
      child: new Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: new NetworkImage(
                photoUrls[joinNameList.indexOf(nameOfCommenter)]),
            radius: 20.0,
          ),

        ],
      )
    );
  }

  feedBackViewChildCommentBoc(String nameOfCommenter, String comment, String rate){
    return new Container(

      child: new Column(
        children: <Widget>[
          new Text(nameOfCommenter),
          new Text(rate),
          new Text(comment),
        ],
      ),
    );

  }

  commentRateView(List<Widget> comments) {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          comments.length > 0
              ? new Text(AppStringClass.INV_DTL_USER_CMNTS,
                  style: TextStyle(fontSize: 20))
              : new Container(),
          new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: comments,
          )
        ],
      ),
    );
  }

  List<Widget> userComments() {
    List<Widget> usercomments = new List();
    List<InviteJoinees> inviteJoinees = invite.getJoinees();
    for (int i = 0; i < inviteJoinees.length; i++) {
      InviteJoinees iJ = inviteJoinees[i];
      if (null != iJ.getComment() && iJ.getComment().toString() != "") {
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

  commentRateEditor_dialog() {
    _navigateAndDisplaySelection(bContext);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new UserCommentRateDialog(
        invite: invite,
      )),
    );
    if(result=="success"){
      navigate();
    }
  }


  commentRateEditor() {
    return new SingleChildScrollView(
      child: new Container(
        height: MediaQuery.of(bContext).size.height * 0.4,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SmoothStarRating(
                allowHalfRating: true,
                onRatingChanged: (v) {
                  rating = v;
                  setState(() {
                    rating = v;
                  });
                },
                starCount: 5,
                rating: rating,
                size: 30.0,
                color: Colors.lightBlue.shade800,
                borderColor: Colors.lightBlue.shade800,
                spacing: 0.0),
            SizedBox(
              height: 10,
            ),
            new Text(AppStringClass.INV_DTL_USER_CMNTS_EDIT_HINT),
            SizedBox(
              height: 5,
            ),
            new TextFormField(
              obscureText: false,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              onSaved: (String val) {
                _comment = val;
                _formdata['_comment'] = _comment;
              },
              validator: (String arg) {
                if (arg.length < 10) {
                  return AppStringClass.INV_DTL_USER_CMNTS_EDIT_ERR;
                } else
                  return null;
              },
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  errorStyle: TextStyle(
                      color: Colors.red, wordSpacing: 1.0, fontSize: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0))),
            ),
            SizedBox(
              height: 10,
            ),
            new Center(
              child: new FlatButton(
                child: Text(AppStringClass.INV_DTL_SUBMIT_BUTTON),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    setState(() {
                      _isLoading = true;
                    });
                    inviteListPresenter.commentAndRate(
                        invite.id, _comment, rating.toString());
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
      _isLoading = false;
    });
    navigate();
  }

  @override
  void updateViewsStartInvite(String status) {
    // TODO: implement updateViews
    setState(() {
      _isLoading = false;
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
          child: const ModalBarrier(
              dismissible: false, color: AppColors.BackgroundColor),
        ),
        new Center(
          child: new CircularProgressIndicator(),
        ),
      ],
    );
    return modal;
  }
}

class UserCommentRateDialog extends StatefulWidget {
  Invite invite;

  UserCommentRateDialog({Key key, this.invite}) : super(key: key);

  @override
  _UserCommentRateDialogState createState() =>
      new _UserCommentRateDialogState(invite);
}

class _UserCommentRateDialogState extends State<UserCommentRateDialog>  implements InviteDetailCommentUpdateCallback {
  double rating = 0.0;
  Invite invite;
  BuildContext bContext;
  var _formKey = GlobalKey<FormState>();
  Map _formdata = new Map();
  var _comment;
  bool _isLoading = false, isLeave = false;
  InviteListPresenter inviteListPresenter;
  _UserCommentRateDialogState(this.invite);

  @override
  void initState() {
    // `TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(null);
    inviteListPresenter.setInviteDetailCommentUpdate(this);
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return AlertDialog(
      content: new SingleChildScrollView(
        child:
        Form(
        key: _formKey,
        child:
        new Container(
          height: MediaQuery.of(bContext).size.height * 0.45,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new SmoothStarRating(
                  allowHalfRating: true,
                  onRatingChanged: (v) {
                    rating = v;
                    setState(() {
                      rating = v;
                    });
                  },
                  starCount: 5,
                  rating: rating,
                  size: 30.0,
                  color: Colors.lightBlue.shade800,
                  borderColor: Colors.lightBlue.shade800,
                  spacing: 0.0),
              SizedBox(
                height: 10,
              ),
              new Text(AppStringClass.INV_DTL_USER_CMNTS_EDIT_HINT),
              SizedBox(
                height: 5,
              ),
              new TextFormField(
                obscureText: false,
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                onSaved: (String val) {
                  _comment = val;
                  _formdata['_comment'] = _comment;
                },
                validator: (String arg) {
                  if (arg.length < 10) {
                    return AppStringClass.INV_DTL_USER_CMNTS_EDIT_ERR;
                  } else
                    return null;
                },
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    errorStyle: TextStyle(
                        color: Colors.red, wordSpacing: 1.0, fontSize: 10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0))),
              ),
              SizedBox(
                height: 10,
              ),
              Center(child: Padding(
                padding: EdgeInsets.all(5),
                child:
                _isLoading?new CircularProgressIndicator():new Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(7.0),
                  color: isLeave ? Colors.red : AppColors.SecondaryColor,
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      MaterialButton(
                        padding:
                        EdgeInsets.only(right: 5, left: 5),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            setState(() {
                              _isLoading = true;
                            });
                            inviteListPresenter.commentAndRate(
                                invite.id, _comment, rating.toString());
                          }
                        },
                        child: Text(AppStringClass.INV_DTL_SUBMIT_BUTTON,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 20.0,
                                color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: new Icon(
                          Icons.rate_review,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),),
            ],
          ),
        ),
      ),
      )
    );
  }

  @override
  void commentedUpdated(String status) {
    // TODO: implement commentedUpdated
    Navigator.pop(bContext,"Success");
  }

  @override
  void showErrorDialog(String error) {
    // TODO: implement showErrorDialog
    Navigator.pop(bContext,"Failure");
  }
}
