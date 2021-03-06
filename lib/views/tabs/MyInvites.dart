import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';

import '../InviteDetailScreen.dart';




void main() => runApp(MyInvitesScreen());

class MyInvitesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: MyInvites(),
      ),
    );
  }

}

class MyInvites extends StatefulWidget {
  final String title;
  MyInvites({Key key, this.title}) : super(key: key);

  @override
  _MyInvitesState createState() => new _MyInvitesState();
}

class _MyInvitesState extends State<MyInvites> implements InviteListCallBack {
  List<Invite> _upcomingEvents = new List<Invite>();
  List<Invite> _pastEvents = new List<Invite>();
  List<Invite> _suggestions = new List<Invite>();
  InviteListPresenter inviteListPresenter;
  var asyncUpcoming,ayncPast;
  bool _isLoading = false;




  @override
  Future initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(this);
    inviteListPresenter.pastEvents();
    inviteListPresenter.upComingEvents();
    _isLoading = true;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: AppColors.PrimaryColor,
          title: new Text('My Invites'),
        ),
        body: SingleChildScrollView(
          child: new Container(
            decoration: new BoxDecoration(color: AppColors.BackgroundColor),
            child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                child: Text('Upcoming Events',
                  style: TextStyle(fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade500),
                  textAlign: TextAlign.left,),),

              _buildListView(_upcomingEvents),

              Container(
                  alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                  child: Text(
                    'Past Events',
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500),
                    textAlign: TextAlign.left,
                  )),

            _buildListView(_pastEvents),

              Container(
                  alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                  child: Text(
                    'Bookmarked Events',
                    style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500),
                    textAlign: TextAlign.left,
                  )),

             _buildListView(_pastEvents),

            ],
          ),
        )
    ));
  }


  Widget _buildListView(List<Invite> invitesList ) {

    return SizedBox(height: 300.0,
      child: ListView.builder(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: invitesList.length,
          itemBuilder: (context, index) =>
              GestureDetector(
                onTap: () =>

                    Scaffold.of(context).showSnackBar(
                        new SnackBar(
                          content: navigateToDetails(invitesList[index]),
                        )),

                child: Card(

                  child: Container(width: 200,
                      height: 300,
                      child: Column(children: <Widget>[
                        Image.network(
                          AppStringClass.APP_BASE_URL+"cat_img/"+invitesList[index].image,
                          height: 150, width: 150,), Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.all(10),

                            child: Text(
                              invitesList[index].title,
                              style: TextStyle(
                                  color: Colors.indigo,
                                  fontWeight: FontWeight
                                      .bold,
                                  fontSize: 12.0),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              child: Container(
                                padding: EdgeInsets
                                    .fromLTRB(10, 2, 0, 0),
                                child: Text(
                                  invitesList[index]
                                      .created_date,
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight
                                          .bold,
                                      fontSize: 12.0),
                                ),
                              )),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets
                                    .fromLTRB(10, 2, 0, 0),
                                child: Text(
                                  invitesList[index].time,
                                  style: TextStyle(
                                      color: Colors.black38,
                                      fontWeight: FontWeight
                                          .bold,
                                      fontSize: 12.0),
                                )),
                          )
                        ]),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: EdgeInsets.fromLTRB(
                                10, 2, 0, 0),
                            child: Text(
                              invitesList[index].venue,
                              style: TextStyle(
                                  color: Colors.black38,
                                  fontWeight: FontWeight
                                      .normal,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),


                      ],

                      )
                  ),


                ),
              )

      ),
    );

  }

  @override
  void showError() {
    // TODO: implement showError
  }

  @override
  void updateViews(List<Invite> invitedata) {
    // TODO: implement updateViews


    @override
    void showErrorDialog(String error) {
      // TODO: implement showErrorDialog
    }
  }

  @override
  void showErrorDialog(String error) {
    // TODO: implement showErrorDialog
  }

  @override
  void updateViewsPastInvites(List<Invite> invitedata) {
    // TODO: implement updateViewsPastInvites

      setState(() {
        _pastEvents = invitedata;

      });

  }

  @override
  void updateViewsUpcomingInvites(List<Invite> invitedata) {
    // TODO: implement updateViewsUpcomingInvites

    setState(() {
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
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      inviteListPresenter.clearInviteList();
      inviteListPresenter.GetInviteList(false);
    }
  }




}
