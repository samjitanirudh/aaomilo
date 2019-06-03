import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';




class InviteListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Invite List",
      home: new Scaffold(
        appBar: new AppBar(
          title: Text("Invite List"),
        ),
        body: InviteList(),
      ),
    );
  }
}

class InviteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new InviteListState();
  }
}

class InviteListState extends State<InviteList> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return new Container(
//      decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child:Scrollbar(
        child: ListView.builder(
        itemCount: 10,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int i) {
//          if (i.isOdd) return Divider();
          final index = i;
          // If you've reached the end of the available word pairings...
          if (index >= _suggestions.length) {
            // ...then generate 10 more and add them to the suggestions list.
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return new Padding(padding: EdgeInsets.only(bottom: 3,left: 2,right: 2,top: 3 ),
            child :Card(
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
    );
  }

  Widget _buildRow(WordPair pair) {
    return new ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 0.0),
      title: Column(children: <Widget>[Container(
          width: MediaQuery.of(context).size.width,
          height: 150,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/yoga.jpg"),fit: BoxFit.fill)),
      ),Align(
        alignment: Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(
            pair.asPascalCase,
            style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.bold,fontSize: 18.0),
            ),
        ),
      ),
      Row(children: <Widget>[
        Expanded(
          child:Container(
            padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
            child: Text(
              "Date: " + "06/01/2019",
              style: TextStyle(color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )),
        Expanded(
          child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 0, 0),
              child: Text(
                "Time: " + "13.46.00",
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
            "Time Square , Ground floor common area",
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
                            image: AssetImage("assets/group.png"),
                            fit: BoxFit.fill))
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(3,0,3,0),
                      child: Text(
                        "06/10",
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
                                image: AssetImage("assets/comment.png"),
                                fit: BoxFit.fill))
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(3,0,3,0),
                          child: Text(
                            "04",
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
                            image: AssetImage("assets/favourites.png"),
                            fit: BoxFit.fill))
                    ),
                  )
                 ),
//          Expanded(
//            flex: 4,
//            child: Padding(
//                padding: EdgeInsets.only(left: 10.0),
//                child: Text(pair.asPascalCase,
//                    style: TextStyle(color: Colors.white))),
//          )
            ],
          )),
//      trailing:
//      Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
//      onTap: () {
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => DetailPage(lesson: lesson)));
//      },
    );
  }
}
