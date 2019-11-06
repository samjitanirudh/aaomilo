import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';

import 'InviteDetailScreen.dart';

class MyInvitesN extends StatefulWidget {
  final String title;
  MyInvitesN({Key key, this.title}) : super(key: key);

  @override
  MyInvitesNState createState() => new MyInvitesNState();
}

class MyInvitesNState extends  State<MyInvitesN> implements InviteListCallBack{

  List<Invite> _upcomingEvents = new List<Invite>();
  List<Invite> _pastEvents = new List<Invite>();
  List<Invite> _bookmarks = new List<Invite>();
  InviteListPresenter inviteListPresenter;
  bool _isUpCommingLoading=false;
  bool _isPasrLoading=false;
  var categoryImageAPI = AppStringClass.APP_BASE_URL+"cat_img/";
  BuildContext bContext;

  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(this);
    refreshPastEvnts();
    refreshUpcommingEvnts();
  }

  refreshPastEvnts(){
    if (mounted) {
      setState(() {
        _isPasrLoading= true;
      });
    }
    inviteListPresenter.pastEvents();
  }

  refreshUpcommingEvnts(){
    if (mounted) {
      setState(() {
        _isUpCommingLoading = true;
      });
    }
    inviteListPresenter.upComingEvents();
  }

  @override
  Widget build(BuildContext context) {
    bContext=context;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SplashScreen',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.PurpleVColor
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.next_week),text: "Future invites",),
                Tab(icon: Icon(Icons.hourglass_empty),text: "Past invites",),
                Tab(icon: Icon(Icons.bookmark),text: "Bookmarked",),
              ],
            ),
            title: Text('My Invites'),
          ),
          body: TabBarView(
            children: [
              _isUpCommingLoading ? loaderOnViewUpdate() : _buildSuggestions(_upcomingEvents),
              _isPasrLoading ? loaderOnViewUpdate() : _buildSuggestions(_pastEvents),
              Icon(Icons.not_listed_location),
            ],
          ),
        ),
      ),
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


  Widget _buildSuggestions(List<Invite> _suggestions) {
    if(_suggestions.length>0) {
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
          onRefresh: _refreshStockPrices,),
      );
    }else {
      return emptyInvitesWithRefreshbtn();
    }
  }

  emptyInvitesWithRefreshbtn(){
    return new Container(
      width: MediaQuery.of(bContext).size.width,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("No invites joined!"),
          new FlatButton(onPressed: refreshUpcommingEvnts, child: new Text("Refresh"))
        ],
      ),
    );
  }

  Future<void> _refreshStockPrices() async {
    if (mounted) {
      setState(() {
        _isUpCommingLoading = true;
        _isPasrLoading=true;
      });
    }
    inviteListPresenter.clearInviteList();
    refreshPastEvnts();
    refreshUpcommingEvnts();
  }

  Widget _buildRow(Invite invite) {
    bool loaded = false;
    NetworkImage nI = new NetworkImage(categoryImageAPI+invite.image);
    nI.resolve(new ImageConfiguration()).addListener(new ImageStreamListener((_, __) {
      if (mounted) {
        setState(() {
          loaded = true;
        });
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
                    image: loaded ?DecorationImage(
                        image:nI,fit: BoxFit.fill):DecorationImage(
                        image: AssetImage("assets/images/pulse.gif"),fit: BoxFit.none)),
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
        ]),
      ]),
      subtitle: new Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(left: 0,right: 5),
          child: Row(
            children: <Widget>[
//              Expanded(
//                  flex: 1,
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.start,
//                    children: <Widget>[
//                      Container(
//                        child: new Icon(
//                          Icons.group,
//                          color: AppColors.PurpleVColor,
//                        ),
//                      ),
//                      SizedBox(width: 5,),
//                      Container(
//                        child: Text(
//                          invite.joined + "/" + invite.allowed_member_count,
//                          style: TextStyle(
//                              color: AppColors.PurpleVColor,
//                              fontWeight: FontWeight.bold,
//                              fontSize: 18.0),
//                        ),
//                      )
//                    ],
//                  )),
              new Icon(Icons.place,color: AppColors.PurpleVColor,),
              Container(
                padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                child: Text(
                  invite.venue,
                  style: TextStyle(
                      color: AppColors.PurpleVColor,
                      fontWeight: FontWeight.normal,
                      fontSize: 14.0),
                ),
              )
//              Expanded(
//                  flex: 1,
//                  child: Align(
//                      alignment: Alignment.center,
//                      child: Container(
//                        child: new Icon(
//                          Icons.comment,
//                          color: AppColors.PurpleVColor,
//                        ),
//                      ))),
//              Expanded(
//                  flex: 1,
//                  child: Align(
//                      alignment: Alignment.center,
//                      child: Container(
//                        child: new Icon(
//                          Icons.rate_review,
//                          color: AppColors.PurpleVColor,
//                        ),
//                      )))
            ],
          )),
    );
  }


  @override
  void showError() {
    // TODO: implement showError
  }

  @override
  void showErrorDialog(String error) {
    // TODO: implement showErrorDialog
  }

  @override
  void updateViews(List<Invite> invitedata) {
    // TODO: implement updateViews
  }

  @override
  void updateViewsPastInvites(List<Invite> invitedata) {
    setState(() {
      _isPasrLoading=false;
      _pastEvents = invitedata;
    });
  }

  @override
  void updateViewsUpcomingInvites(List<Invite> invitedata) {
    setState(() {
      _isUpCommingLoading=false;
      _upcomingEvents = invitedata;
    });
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
      inviteListPresenter.clearInviteList();
      inviteListPresenter.GetInviteList(false);
    }
  }


}