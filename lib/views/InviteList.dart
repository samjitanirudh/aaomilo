import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/InviteListModel.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';
import 'package:flutter_meetup_login/views/InviteDetailScreen.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';

class InviteList extends StatefulWidget {
  String selectedCategoryList;
  final FirebaseAnalytics analytics;

  InviteList({Key key, this.analytics,String selectedIndexList})
      : selectedCategoryList = selectedIndexList,
        super(key: new ObjectKey(""));

  @override
  State<StatefulWidget> createState() {
    return new InviteListState(analytics:analytics,selectedCategoriesId: selectedCategoryList);
  }
}

class InviteListState extends State<InviteList> implements InviteListCallBack {
  final FirebaseAnalytics analytics;
  List<Invite> _suggestions = new List<Invite>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  InviteListPresenter inviteListPresenter;
  static const platform =
      const MethodChannel('samples.flutter.dev/ssoanywhere');
  BuildContext bContext;
  bool _isLoading = false;

  String selectedCatList;

  String selectedCategoriesId;
  int index = 0;
  List<Categories> cList = new List();
  var categoryImageAPI = AppStringClass.APP_BASE_URL+"cat_img/";

  InviteListState({Key key, this.analytics,this.selectedCategoriesId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _setCurrentScreen();
    cList = new CategoryClass().getCategoryList();
    inviteListPresenter = new InviteListPresenter(this);
    _isLoading = true;
    inviteListPresenter.GetInviteList(false);
  }

  Future<void> _setCurrentScreen() async {
    await analytics.setCurrentScreen(
      screenName: "Invite List",
      screenClassOverride: 'InviteList',
    );
  }

  Future<void> _refreshStockPrices() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    inviteListPresenter.clearInviteList();
    inviteListPresenter.GetInviteList(false);
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.PurpleVColor,
            title: Text("Invites"),
            textTheme: TextTheme(
                title: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ))),
        body: new Stack(
          children: <Widget>[
            _isLoading ? loaderOnViewUpdate() : _buildSuggestions()
          ],
        ));
  }

  Widget _buildSuggestions() {
    if(_suggestions.length>0)
      return new Container(
      child: new RefreshIndicator(
          child: Scrollbar(
              child: ListView.builder(
            itemCount: _suggestions.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int i) {
              final index = i;
              return new Padding(
                  padding:
                      EdgeInsets.only(bottom: 3, left: 3, right: 3, top: 3),
                  child: Card(
                    elevation: 15.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: new Container(
                      decoration:
                          new BoxDecoration(color: Colors.white),
                      child: _buildRow(_suggestions[index]),
                    ),
                  ));
            },
          )),
          onRefresh: _refreshStockPrices),
    );
    else
      return new Text("No open invites available to join..!, Create one");
  }

  Widget _buildRow(Invite invite) {
    bool loaded = false;
    NetworkImage nI = new NetworkImage(categoryImageAPI+invite.image);
    nI.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
//        setState(() {
//          loaded = true;
//        });
      }
    }));
    return new ListTile(
      onTap: () => navigateToDetails(invite),
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      title: new Column(children: <Widget>[
        new Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:nI,fit: BoxFit.fill)),
            )
        ]),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Text(
              invite.title.toString().toUpperCase(),
              style: TextStyle(
                  color: AppColors.lightBlueVColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
        ),
        Row(children: <Widget>[
          new Icon(Icons.timer,color: AppColors.PurpleVColor,),
          Expanded(
              child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(invite.created_date +" @ "+invite.time,
                  style: TextStyle(
                      color: AppColors.PurpleVColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
            ),
          )),
          new Icon(Icons.place,color: AppColors.PurpleVColor,),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(
                invite.venue,
                style: TextStyle(
                    color: AppColors.PurpleVColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0),
              ),
            ),
          )
        ]),
      ]),
      subtitle: new Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 5,right: 5),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        child: new Icon(
                          Icons.group,
                          color: AppColors.PurpleVColor,
                        ),
                      ),
                      SizedBox(width: 5,),
                      Container(
                        child: Text(
                          invite.joined + "/" + invite.allowed_member_count,
                          style: TextStyle(
                              color: AppColors.PurpleVColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0),
                        ),
                      )
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: new Icon(
                          Icons.comment,
                          color: AppColors.PurpleVColor,
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: new Icon(
                          Icons.rate_review,
                          color: AppColors.PurpleVColor,
                        ),
                      )))
            ],
          )),
    );
  }

  navigateToDetails(final Invite inv) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteDetailScreen(invite: inv),
      ),
    ).then((dynamic value) {
      returnedFromInviteDetailsScreen(value);
    });
  }

  returnedFromInviteDetailsScreen(dynamic value) {
    if (null != value && value) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      inviteListPresenter.clearInviteList();
      inviteListPresenter.GetInviteList(false);
    }
  }

  @override
  void showError() {
    // TODO: implement showError
  }

  @override
  void updateViews(List<Invite> invitedata) {
    // TODO: implement updateViews
    if (mounted) {
      setState(() {
        _isLoading = false;
        _suggestions = invitedata;
      });
    }
  }

  @override
  void showErrorDialog(String errorMesage) {
    if (errorMesage == "sessionExpired") {
      _showDialogNavigation(
          bContext, "Fetching Invite List", errorMesage, tokenExpired());
    } else
      _showDialog(bContext, "Fetching Invite List", errorMesage, true);
  }

  tokenExpired() {
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }

  void _showDialogNavigation(
      BuildContext context, String title, String content, Function fun) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(""),
              onPressed: fun,
            ),
          ],
        );
      },
    );
  }

  //Dialog to notify user about invite creation result
  void _showDialog(
      BuildContext context, String title, String content, bool isError) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: new Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Ok"),
              onPressed: () {
                if (isError)
                  inviteListPresenter.refreshToken();
                else
                  updateViews(InviteListModel().getInstance().getInviteList());
              },
            ),
          ],
        );
      },
    );
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

  @override
  void updateViewsPastInvites(List<Invite> invitedata) {
    // TODO: implement updateViewsPastInvites
  }

  @override
  void updateViewsUpcomingInvites(List<Invite> invitedata) {
    // TODO: implement updateViewsUpcomingInvites
  }
}
