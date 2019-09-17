import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/InviteList.dart';
import 'package:flutter_meetup_login/utils/AppStringClass.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class CategoriesTab extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
    );
  }
}

class CategoriesTabs extends StatefulWidget {
  TabController _tabController;
  CategoriesTabs(this._tabController, {Key key, this.title}) : super(key: key);

  final String title;




  @override
  _MyHomePageState createState() => _MyHomePageState(controller: this._tabController);
}

class _MyHomePageState extends State<CategoriesTabs> {
  List<Categories> _imageList = List();
  List<String> _categoryLsit = List();
  List<int> _selectedIndexList = List();
  bool _selectionMode = false;
  List<Categories> cList = List();
  int _tabIndex = 0;
  TabController controller;

  _MyHomePageState({this.controller});

  var categoryImageAPI = AppStringClass.APP_BASE_URL+"cat_img/";

  @override
  Widget build(BuildContext context) {
    List<Widget> _buttons = List();

    if (_selectionMode) {
      _buttons.add(IconButton(
          icon: new Text("Next"),
          onPressed: () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(
//                  builder: (context) => InviteListScreen(usernameController)));

            controller.animateTo(0);

          }));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Categories"),
        textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            )),
        actions: _buttons,
      ),
      body: _createBody(),
    );
  }

  @override
  void initState() {
    super.initState();

    cList = new CategoryClass().getCategoryList();

  }

  void _changeSelection({bool enable, int index}) {
    _selectionMode = enable;
    _selectedIndexList.add(index);
    if (index == -1) {
      _selectedIndexList.clear();
    }
  }

  Widget _createBody() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 2,
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      primary: false,
      itemCount: cList.length,
      itemBuilder: (BuildContext context, int index) {
        return getGridTile(index);
      },
      staggeredTileBuilder: (int index) => StaggeredTile.count(1, 1),
      padding: const EdgeInsets.all(4.0),
    );
  }

  GridTile getGridTile(int index) {
    if (_selectionMode) {
      return GridTile(
        header: GridTileBar(
          leading: Icon(
            _selectedIndexList.contains(index)
                ? Icons.check_circle_outline
                : Icons.radio_button_unchecked,
            color: _selectedIndexList.contains(index)
                ? Colors.green
                : Colors.black,
          ),
        ),
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
                          image: NetworkImage(categoryImageAPI + cList[index].imgUrl),
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
              _changeSelection(enable: false, index: -1);
            });
          },
          onTap: () {
            setState(() {
              if (_selectedIndexList.contains(index)) {
                _selectedIndexList.remove(index);
              } else {
                _selectedIndexList.add(index);
              }
            });
          },

      ));
    } else {
      return GridTile( child: GestureDetector(child: Container(

          decoration: BoxDecoration(color: Colors.blue[50],shape: BoxShape.rectangle),
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 120,
                height: 120,
                alignment: Alignment.bottomCenter,
                padding: EdgeInsets.all(50),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(categoryImageAPI + cList[index].imgUrl),
                        fit: BoxFit.cover)),

              ),
              Text(
                cList[index].txtCategoryName,
                textAlign: TextAlign.center,style: TextStyle(fontSize:15,),
              ),
            ],
          )
      ),
        onLongPress:() {
        setState(() {
          _changeSelection(enable: true, index: index);
        });
        },
      ),
      );

    }
  }
}
