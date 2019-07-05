import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';
import 'package:flutter_meetup_login/presenter/InviteListPresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/Invite.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/views/InviteDetailScreen.dart';

import 'viewmodel/InviteListModel.dart';

class InviteList extends StatefulWidget {

  String selectedCategoryList;
  InviteList(String selectedIndexList): selectedCategoryList=selectedIndexList,super(key: new ObjectKey(""));

  @override
    State<StatefulWidget> createState() {
    return new InviteListState(selectedCategoriesId: selectedCategoryList);
  }
}

class InviteListState extends State<InviteList> implements InviteListCallBack {
  List<Invite> _suggestions = new List<Invite>();
  final _biggerFont = const TextStyle(fontSize: 18.0);
  InviteListPresenter inviteListPresenter;
  static const platform =
      const MethodChannel('samples.flutter.dev/ssoanywhere');
  BuildContext bContext;

  String selectedCatList;

  String selectedCategoriesId;
  int index = 0;
  List<Categories> cList = new List();
  var categoryImageAPI = "http://convergepro.xyz/meetupapi/cat_img/";

  InviteListState({this.selectedCategoriesId});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inviteListPresenter= new InviteListPresenter(this);
    inviteListPresenter.GetInviteList(selectedCategoriesId, null);
    cList = new CategoryClass().getCategoryList();

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
          actions: <Widget>[
      new IconButton(
      icon: new Icon(Icons.filter_list), color: Colors.white,padding: EdgeInsets.all(20),
      onPressed: () {

//        Navigator.push(
//          context,
//          MaterialPageRoute(
//              builder: (context) =>
//                  CategoriesTabs(categoryCallbacks: this)),
//        );

        _categoryListView();


//        Navigator.of(context).pushNamed('/CategoriesTab');
      },
    ),
    ]

      ),
      body: _buildSuggestions(),
    );
  }




  Future<Null> _categoryListView() async {
    return showDialog<Null>(
      context: context,
      // user must tap button!
      child: new AlertDialog(
        contentPadding: const EdgeInsets.all(50.0),
        title: new Text(
          'SAVED !!!',
          style:
          new TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        content: new Container(
          // Specify some width
          width: MediaQuery.of(context).size.width ,
          height: 100,
          child: new GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.0,
              padding: const EdgeInsets.all(7.0),
              mainAxisSpacing: 10,
              crossAxisSpacing:5.0,
              children: getOption()),
        ),
        actions: <Widget>[
          new IconButton(
              splashColor: Colors.green,
              icon: new Icon(
                Icons.done,
                color: Colors.blue,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
    );
  }

  List<Widget> getOption() {
    List<Widget> options = new List();
    for (int i = 0; i < cList.length; i++)
      options.add(
//          new SimpleDialogOption(
//        onPressed: () {
//          Navigator.pop(context, i);//here passing the index to be return on item selection
//        },
//        child: new Text(cList[i].txtCategoryName),// /item value
//      )
      new Container(width:MediaQuery.of(context).size.width,height: 200, child: new GridView.count(crossAxisCount: 2,
      shrinkWrap: true,
      children: new List<Widget>.generate(1, (index) {
        return new GridTile(

            child: GestureDetector( child: Container(

                decoration: BoxDecoration(color: Colors.blue.shade50,shape: BoxShape.rectangle),
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(categoryImageAPI + cList[i].imgUrl),
                              fit: BoxFit.cover)),

                    ),
                    Text(
                      cList[index].txtCategoryName,
                      textAlign: TextAlign.center,style: TextStyle(fontSize:15,),
                    ),
                  ],
                )
            ),
              onLongPress: () {
                setState(() {
//                  _changeSelection(enable: false, index: -1);
                });
              },
              onTap: () {
                setState(() {
//                  if (_selectedIndexList.contains(index)) {
//                    _selectedIndexList.remove(index);
//                  } else {
//                    _selectedIndexList.add(index);
//                  }
                });
              },

            )
        );
      }
      )
      ),)
      );

    return options;
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
    inviteListPresenter.clearInviteList();
    inviteListPresenter.GetInviteList(null, null);
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
    );
    Navigator.of(bContext).pushNamed('/InviteDetailsScreen');
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
}
