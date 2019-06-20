import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';

class MyInvites extends StatefulWidget {
  final String title;
  MyInvites({Key key, this.title}) : super(key: key);

  @override
  _MyInvitesState createState() => new _MyInvitesState();
}

class _MyInvitesState extends State<MyInvites> implements InviteListCallBack{
  List<Invite> _suggestions = new List<Invite>();
  InviteListPresenter inviteListPresenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter= new InviteListPresenter(this);
    inviteListPresenter.GetInviteList();
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('My Invites'),
        ),
        body:  SingleChildScrollView(

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
                child: Text('Upcoming Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade500),
                textAlign: TextAlign.left,),),

              SizedBox( height: 300.0,

                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: _suggestions.length,
                  itemBuilder: (BuildContext context, int index) => Card(

                    child:Container( width:200,
                        height: 300,
                        child: Column(children: <Widget>[Image.network(_suggestions[index].image, height: 200, width: 200,),Align(
                          alignment: Alignment.centerLeft,
                          child: Container(

                            child: Text(
                              _suggestions[index].title,
                              style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,fontSize: 12.0),
                            ),
                          ),
                        ),
                        Row(children: <Widget>[
                          Expanded(
                              child:Container(
                                padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                                child: Text(
                                  "Date: " + _suggestions[index].created_date,
                                  style: TextStyle(color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              )),
                          Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
                                child: Text(
                                  "Time: " + _suggestions[index].time,
                                  style: TextStyle(color: Colors.black38,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                )),
                          )
                        ])
                        ],)
                    ),



                  ),
                ),

              ),

              Container(alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
              child:Text(
                'Past Events',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold,color: Colors.blue.shade500),
                textAlign: TextAlign.left,
              )),

           SizedBox(
                height: 200.0,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),
              Container(alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
               child: Text(
                'Bookmarked Events',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue.shade500),
                textAlign: TextAlign.left,
              )),

           SizedBox(
                height: 200.0,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),
              Container(alignment: Alignment.topLeft, padding: EdgeInsets.all(5),
              child:Text(
                'Created by me',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.blue.shade500),
                textAlign: TextAlign.left,
              )),

          SizedBox(
                height: 200.0,
                child: ListView.builder(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) => Card(
                    child: Center(child: Text('Dummy Card Text')),
                  ),
                ),
              ),

            ],
          ),
        ));}

  @override
  void showError() {
    // TODO: implement showError
  }

  @override
  void updateViews(List<Invite> invitedata) {
    // TODO: implement updateViews
    _suggestions=invitedata;
  }

  Widget _buildRow(Invite invite) {
    bool loaded=false;
    //print(invite.image);
    NetworkImage nI= new NetworkImage("http://"+invite.image);
    nI.resolve(new ImageConfiguration()).addListener((_,__){
      if(mounted){
        setState(() {
          print("image loaded");
          loaded=true;
        });
      }
    });
    return new ListTile(
//      contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      title: Column(children: <Widget>[Container(
        width:30,
        height: 200,
        decoration: BoxDecoration(image:
        DecorationImage(
            image: loaded?nI:AssetImage("assets/images/pulse.gif"),
            fit: BoxFit.fill)
        ),
      ),Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(
            invite.title,
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,fontSize: 18.0),
          ),
        ),
      ),
      Row(children: <Widget>[
        Expanded(
            child:Container(
              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(
                "Date: " + invite.created_date,
                style: TextStyle(color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            )),
        Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(
                "Time: " + invite.time,
                style: TextStyle(color: Colors.black38,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              )),
        )
      ]),Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
          child: Text(
            invite.venue,
            style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal,fontSize: 16.0),
          ),
        ),
      )]),
      subtitle: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          padding: EdgeInsets.fromLTRB(5, 10, 0, 2),
          child: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(image: DecorationImage(
                            image: AssetImage("assets/images/group.png"),
                            fit: BoxFit.fill))
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(3,0,3,0),
                      child: Text(
                        invite.joined+"/"+invite.allowed_member_count,
                        style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal,fontSize: 18.0),
                      ),
                    )
                    ],
                  )),

              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(15,0,0,0),
                  child: Row(
                    children: <Widget>[Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(image: DecorationImage(
                            image: AssetImage("assets/images/comment.png"),
                            fit: BoxFit.fill))
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(3,0,3,0),
                      child: Text(
                        "-",
                        style: TextStyle(color: Colors.black38, fontWeight: FontWeight.normal,fontSize: 18.0),
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
                        decoration: BoxDecoration(image: DecorationImage(
                            image: AssetImage("assets/images/favourites.png"),
                            fit: BoxFit.fill))
                    ),
                  )
              ),

            ],
          )),

    );
  }
}


