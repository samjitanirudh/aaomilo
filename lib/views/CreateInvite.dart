import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/ImageListviewChecked.dart';

class CreateInvite extends StatefulWidget {
  CreateInvite({Key key}) : super(key: key);

  @override
  _CreateInvite createState() => new _CreateInvite();
}

class _CreateInvite extends State<CreateInvite> {
  static final TextStyle textStyle = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.blue.shade900);
  var _formKey = GlobalKey<FormState>();
  var _formview;
  bool _isLoading = false;
  BuildContext bContext;
  var _CategoryValue;
  DateTime selectedDate = DateTime.now();
  String selectedDateValue = "";
  String selectedTimeValue = "0";
  List inviteTimeRange = new List();
  var _VanueValue; // time array for invites

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selectedDateValue = selectedDate.day.toString() +
            '/' +
            selectedDate.month.toString() +
            '/' +
            selectedDate.year.toString();
      });
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.blue.shade900,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                new FlutterLogo(),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: new Text(
                    "Create new invite",
                  ),
                ),
              ],
            )),
        body: Builder(builder: (context) => createInviteUI(context)));
  }

  Widget createInviteUI(BuildContext context) {
    _formview = Container(
        color: Colors.blue.shade50,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      titleTextEdit(),
                      categoryDropDownContainer(),
                      categoryPictureSelectView(),
                      descriptionTextEdit(),
                      inviteMembersDropDownContainer(),
                      inviteDateTimeSelect(),
                      vanueDropDownContainer(),
                      Center(
                        child: createInviteButton(),
                      )

                    ]))));
    return _formview;
  }

  titleTextEdit() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: new Row(
              children: <Widget>[
                new Text(
                  "Invite title",
                  style: textStyle,
                )
              ],
            ),
          ),
          new TextFormField(
            obscureText: false,
            style: textStyle,
            onSaved: (String val) {
              //_email = val;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "i.e. Explaining flutter univers",
                errorStyle: TextStyle(
                  color: Colors.white,
                  wordSpacing: 5.0,
                ),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
        ],
      ),
    );
  }

  Container categoryDropDownContainer() {
    return new Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: new Column(
                children: <Widget>[
                  new Text("Category", style: textStyle),
                ],
              ),
            ),
            _CategoryDropDown()
          ],
        ));
  }

  DropdownButton _CategoryDropDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "Technology",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Music",
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _CategoryValue = value;
          });
        },
        value: _CategoryValue,
        elevation: 2,
        isDense: true,
        hint: Text(
          "Please select the category!",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  categoryPictureSelectView() {

    List<Product> imageList=new List<Product>();
    imageList.add(new Product("assets/images/converge.png", 0,-1));
    imageList.add(new Product("assets/images/flutterwithlogo.png", 1,-1));
    imageList.add(new Product("assets/images/datepicker.png", 2,-1));
    imageList.add(new Product("assets/images/converge.png", 3,-1));

    return new Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: new Column(
                children: <Widget>[
                  new Text(
                    "Select your category picture",
                    style: textStyle,
                  )
                ],
              ),
            ),
            new Container(
              height: 150.0,
              child: ListView(
                  scrollDirection: Axis.horizontal,
//                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  children: imageList.map((Product product) {
                    return new ImageListViewChecked(product);
                  }).toList(),
              ),
            )
          ],
        ));
  }

  descriptionTextEdit() {
    return new Container(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Container(
            margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
            child: new Row(
              children: <Widget>[
                new Text(
                  "Invite description",
                  style: textStyle,
                )
              ],
            ),
          ),
          new TextFormField(
            obscureText: false,
            style: textStyle,
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            onSaved: (String val) {
              //_email = val;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "i.e. Describe your invites...",
                errorStyle: TextStyle(
                  color: Colors.white,
                  wordSpacing: 5.0,
                ),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
        ],
      ),
    );
  }

  Container inviteMembersDropDownContainer() {
    return new Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: new Column(
                children: <Widget>[
                  new Text("Max no. of people who can join", style: textStyle)
                ],
              ),
            ),
            _inviteMembersDropDown()
          ],
        ));
  }

  DropdownButton _inviteMembersDropDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "5",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "10",
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            _CategoryValue = value;
          });
        },
        value: _CategoryValue,
        elevation: 2,
        isDense: true,
        hint: Text(
          "Select!",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      );

  inviteDateTimeSelect() {
    return new Container(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Expanded(child:
              new Container(
                  padding: EdgeInsets.fromLTRB(20.0, 15.0, 5.0, 15.0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        new Text("Date",
                            style: new TextStyle(fontWeight: FontWeight.bold,),textAlign: TextAlign.center),
                        SizedBox(height: 5.0),
                        datetimeTextField(),
                      ]
                  )
              )
            ),
            new Container(
                padding: EdgeInsets.fromLTRB(20.0, 15.0, 5.0, 15.0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text("Time",
                          style: new TextStyle(fontWeight: FontWeight.bold,)),
                      SizedBox(height: 5.0),
                      new Container(
                        padding: const EdgeInsets.all(3.0),
                        decoration: new BoxDecoration(
                            borderRadius:BorderRadius.all(Radius.circular(32.0)),
                            border: new Border.all(color: Colors.black38)
                        ),
                        child:inviteTimePicker(),
                      )
                    ]
                )
            )
          ],
    ));
  }

  TextFormField datetimeTextField() {
    return new TextFormField(
      obscureText: false,
      style: new TextStyle(fontSize: 12),
      textAlign: TextAlign.center,
      onSaved: (String val) {
        //_email = val;
        selectedDateValue = val;
      },
      controller: new TextEditingController(text: selectedDateValue),
      decoration: InputDecoration(
          hintText: "Select date",
          errorStyle: TextStyle(
            fontSize: 12,
            color: Colors.white,
            wordSpacing: 5.0,
          ),
          suffixIcon:new IconButton(icon: Image.asset("assets/images/datepicker.png",width: 24,height: 24,), onPressed: (){
            _selectDate(context);
          }),

          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  DropdownButton inviteTimePicker() {
    return new DropdownButton(
        items: getTimeRanges(),
        value: selectedTimeValue,
        onChanged: (value) {
          setState(() {
            selectedTimeValue = value;
          });
        },
    );
  }

  List<DropdownMenuItem<String>> getTimeRanges() {
    var x = 30; //minutes interval
    var tt = 540; // start time
    var ap = ['AM', 'PM']; // AM-PM
    List timedata = new List();
    //loop to increment the time and push results in array
    for (var i = 0; tt < 20 * 60; i++) {
      // only allowing time slot till 7:30PM
      int hh = (tt / 60).floor(); // getting hours of day in 0-24 format
      var mm = (tt % 60); // getting minutes of the hour in 0-55 format
      String hourvalue = "0" + (hh % 12).toString();
      String minvalue = "0" + mm.toString();

      String times = (hourvalue.substring(
              hourvalue.length - 2, hourvalue.length) +
          ':' +
          minvalue.substring(minvalue.length - 2, minvalue.length) +
          ap[(hh / 12.floor())
              .toInt()]); // pushing data in array in [00:00 - 12:00 AM/PM format]

      tt = tt + x;
      timedata.add(times);
    }
    return getcombinedData(timedata);
  }

  List<DropdownMenuItem<String>> getcombinedData(List timedata) {
    List<DropdownMenuItem<String>> listTime =
        new List<DropdownMenuItem<String>>();
    for (var i = 0; i < ((timedata.length - 1)); i++) {
      var data1 = timedata[i];
      var data2 = timedata[i + 1];
      var tRange = data1 + "-" + data2;
      inviteTimeRange.add(tRange);
      DropdownMenuItem<String> tTime = new DropdownMenuItem<String>(
        child: new Text(tRange,style: new TextStyle(fontSize: 12),),
        value: i.toString(),
      );
      listTime.add(tTime);
    }

    return listTime;
  }

  Container vanueDropDownContainer() {
    return new Container(
        margin: EdgeInsets.fromLTRB(20, 10, 0, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: new Column(
                children: <Widget>[
                  new Text("Vanue", style: textStyle),
                ],
              ),
            ),
            _VanueDropDown()
          ],
        ));
  }

  DropdownButton _VanueDropDown() => DropdownButton<String>(
    items: [
      DropdownMenuItem<String>(
        value: "1",
        child: Text(
          "7th floor cafetaria",
        ),
      ),
      DropdownMenuItem<String>(
        value: "2",
        child: Text(
          "9th floor cafetaria",
        ),
      ),
      DropdownMenuItem<String>(
        value: "3",
        child: Text(
          "TS CCD",
        ),
      ),
      DropdownMenuItem<String>(
        value: "4",
        child: Text(
          "Ground floor teapost",
        ),
      ),
    ],
    onChanged: (value) {
      setState(() {
        _VanueValue = value;
      });
    },
    value: _VanueValue,
    elevation: 2,
    isDense: true,
    hint: Text(
      "Please select the vanue!",
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  createInviteButton(){
    return
        new Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(7.0),
          color: Colors.blue.shade900,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            onPressed: () {
              //
            },
            child: Text("Create invite",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
  }
}
