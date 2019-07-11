import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';

class MyInvites extends StatefulWidget {
  final String title;
  MyInvites({Key key, this.title}) : super(key: key);

  @override
  _MyInvitesState createState() => new _MyInvitesState();
}

class _MyInvitesState extends State<MyInvites> implements InviteListCallBack {
  List<Invite> _suggestions = new List<Invite>();
  List<Invite> _pastEvents = new List<Invite>();
  InviteListPresenter inviteListPresenter;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter = new InviteListPresenter(this);
    inviteListPresenter.upComingEvents();
    inviteListPresenter.pastEvents();
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

              SizedBox(height: 300.0,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: () =>
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                    content: new Text(
                                        "Go to details"),
                                  )),

                          child: Card(
                            child: Container(width: 200,
                                height: 300,
                                child: Column(children: <Widget>[
                                  Image.network(
                                    _suggestions[index].image,
                                    height: 150, width: 150,), Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(10),

                                      child: Text(
                                        _suggestions[index].title,
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
                                            _suggestions[index]
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
                                            _suggestions[index].time,
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
                                        _suggestions[index].venue,
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
              ),

              Container(
                  alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                  child: Text(
                    'Past Events',
                    style: TextStyle(fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500),
                    textAlign: TextAlign.left,
                  )),

              SizedBox(height: 300.0,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _pastEvents.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: () =>
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                    content: new Text(
                                        "Go to details"),
                                  )),

                          child: Card(

                            child: Container(width: 200,
                                height: 300,
                                child: Column(children: <Widget>[
                                  Image.network(
                                    _pastEvents[index].image,
                                    height: 150, width: 150,), Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(10),

                                      child: Text(
                                        _pastEvents[index].title,
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
                                            _pastEvents[index]
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
                                            _pastEvents[index].time,
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
                                        _pastEvents[index].venue,
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
              ),


              Container(
                  alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                  child: Text(
                    'Bookmarked Events',
                    style: TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade500),
                    textAlign: TextAlign.left,
                  )),

              SizedBox(height: 300.0,
                child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: _suggestions.length,
                    itemBuilder: (context, index) =>
                        GestureDetector(
                          onTap: () =>
                              Scaffold.of(context).showSnackBar(
                                  new SnackBar(
                                    content: new Text(
                                        "Go to details"),
                                  )),

                          child: Card(


                            child: Container(width: 200,
                                height: 300,
                                child: Column(children: <Widget>[
                                  Image.network(
                                    _suggestions[index].image,
                                    height: 150, width: 150,), Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      padding: EdgeInsets.all(10),

                                      child: Text(
                                        _suggestions[index].title,
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
                                            _suggestions[index]
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
                                            _suggestions[index].time,
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
                                        _suggestions[index].venue,
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
              ),

            ],
          ),
          )
          ,
        ));
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
        _suggestions = invitedata;
        print(_suggestions.length);
      });
    }


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
    if (mounted) {
      setState(() {
        _pastEvents = invitedata;
        print("past evetns length"+ _pastEvents.length.toString());
      });
    }
  }
}
