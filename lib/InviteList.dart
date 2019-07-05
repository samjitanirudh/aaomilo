import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/views/InviteDetailScreen.dart';

import 'viewmodel/InviteListModel.dart';

class InviteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new InviteListState();
  }
}

class InviteListState extends State<InviteList> implements InviteListCallBack {
  List<Invite> _suggestions = new List<Invite>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  InviteListPresenter inviteListPresenter;
  static const platform =
      const MethodChannel('samples.flutter.dev/ssoanywhere');
  BuildContext bContext;
  bool _isLoading=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(this);
    _isLoading=true;
    inviteListPresenter.GetInviteList(false);
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Invites"),
        textTheme: TextTheme(
            title: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
        )),
      ),
      body:new Stack(
        children: <Widget>[
          _isLoading?loaderOnViewUpdate():_buildSuggestions()
        ],
      )
    );
  }

  Widget _buildSuggestions() {
    return new Container(
//      decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
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
                      EdgeInsets.only(bottom: 3, left: 2, right: 2, top: 3),
                  child: Card(
                    elevation: 8.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3.0),
                    ),
                    child: new Container(
                      decoration: new BoxDecoration(color: Colors.transparent),
                      child: _buildRow(_suggestions[index]),
                    ),
                  ));
            },
          )),
          onRefresh: _refreshStockPrices),
    );
  }

  Future<void> _refreshStockPrices() async {
    if (mounted) {
      setState(() {
        _isLoading=true;
      });
    }
    inviteListPresenter.clearInviteList();
    inviteListPresenter.GetInviteList(false);
  }

  Widget _buildRow(Invite invite) {
    bool loaded = false;
    NetworkImage nI = new NetworkImage(invite.image);
    nI.resolve(new ImageConfiguration()).addListener((_, __) {
      if (mounted) {
        setState(() {
          loaded = true;
        });
      }
    });
    return new ListTile(
      onTap:() => navigateToDetails(invite),
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      title: Column(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: loaded ? nI : AssetImage("assets/images/pulse.gif"),
                  fit: BoxFit.fill)),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
            child: Text(
              invite.title,
              style: TextStyle(
                  color: Colors.indigo,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0),
            ),
          ),
        ),
        Row(children: <Widget>[
          Expanded(
              child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
            child: Text(
              "Date: " + invite.created_date,
              style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )),
          Expanded(
            child: Container(
                padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                child: Text(
                  "Time: " + invite.time,
                  style: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                )),
          )
        ]),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
            child: Text(
              invite.venue,
              style: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0),
            ),
          ),
        )
      ]),
      subtitle: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(5, 10, 0, 2),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/group.png"),
                                  fit: BoxFit.fill))),
                      Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                        child: Text(
                          invite.joined + "/" + invite.allowed_member_count,
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0),
                        ),
                      )
                    ],
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/comment.png"),
                                  fit: BoxFit.fill))),
                      Container(
                        padding: EdgeInsets.fromLTRB(3, 0, 3, 0),
                        child: Text(
                          "-",
                          style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.normal,
                              fontSize: 18.0),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage("assets/images/favourites.png"),
                                fit: BoxFit.fill))),
                  )),
            ],
          )),
    );
  }

  navigateToDetails(Invite inv){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InviteDetailScreen(invite: inv),
      ),
    ).then((dynamic value){
      returnedFromInviteDetailsScreen(value);
    });
  }

  returnedFromInviteDetailsScreen(dynamic value){
    if(null!=value && value){
      if (mounted) {
        setState(() {
          _isLoading=true;
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
        _isLoading=false;
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


