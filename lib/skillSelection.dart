import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SkillSelection extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SkillSelectionState();
  }
}

class _SkillSelectionState extends State<SkillSelection> {
  TextStyle style = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 20.0,
    color: Colors.white,
  );

  List<String> _texts = ["JAVA", "C#", "ASP.NET", "Obj-C", "ODI"];
  Map<String, bool> _textsStatus = new Map<String, bool>();
  var _formKey = GlobalKey<FormState>();
  var _formview;
  var _isChecked = false;
  var _skills="";
  var textController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    _textsStatus[_texts[0]] = false;
    _textsStatus[_texts[1]] = false;
    _textsStatus[_texts[2]] = false;
    _textsStatus[_texts[3]] = false;
    _textsStatus[_texts[4]] = false;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Skill Selection'),
      ),
      body: Builder(builder: (context) => skillSelectionUI(context)),
    );
  }

  Widget skillSelectionUI(BuildContext context) {
    _formview = Container(
        color: Colors.red.shade200,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  SizedBox(height: 25.0),
                  getSkillSelectedText(),
                  SizedBox(height: 25.0),
                  getListView(),
                  SizedBox(height: 25.0),
                  saveSkills(context),
                  SizedBox(height: 15.0)
                ]))));
    return _formview;
  }

  TextFormField getSkillSelectedText() {
    return new TextFormField(
      obscureText: false,
      style: style,
      controller: textController,
      onSaved: (String val) {
          _skills=val;
      },
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Skills",
          errorStyle: TextStyle(
            color: Colors.white,
            wordSpacing: 5.0,
          ),
          border:
              UnderlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
  }

  ListView getListView() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),      //as listview is inside scrollview, added this to allow list scrolling
      padding: EdgeInsets.all(8.0),
      children: _texts
          .map((text) => CheckboxListTile(
                title: Text(text.toString()),
                value: _textsStatus[text],
                onChanged: (val) {
                  setState(() {
                    _isChecked = val;
                    _textsStatus[text] = _isChecked;
                    addRemoveSkill(text,_isChecked);
                  });
                },
              ))
          .toList(),
    );
  }

  Material saveSkills(BuildContext context) {
    return new Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(7.0),
      color: Colors.red.shade700,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width * 0.8,
        padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        onPressed: () {
          //_login();
        },
        child: Text("SAVE",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void addRemoveSkill(String text,bool addRemove){
    _skills="";
    _textsStatus.forEach((String key,bool cStatus){
      if(cStatus)
        _skills=_skills+" "+key;
      });

    textController.text = _skills;
  }

}
