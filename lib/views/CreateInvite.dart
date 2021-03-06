import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/presenter/CreateInvitePresenter.dart';
import 'package:flutter_meetup_login/viewmodel/Categories.dart';
import 'package:flutter_meetup_login/viewmodel/ProfileDataUpdate.dart';
import 'package:flutter_meetup_login/viewmodel/UserProfile.dart';
import 'package:flutter_meetup_login/viewmodel/Venue.dart';
import 'package:flutter_meetup_login/views/ImageListviewChecked.dart';
import 'package:flutter_meetup_login/utils/AppColors.dart';
class CreateInvite extends StatefulWidget {
  CreateInvite({Key key}) : super(key: key);


  @override
  _CreateInvite createState() => new _CreateInvite();


}

class _CreateInvite extends State<CreateInvite> implements ImageSelectedCallbacks,InviteCallbacks{
  static final TextStyle textStyle = TextStyle(
      fontFamily: 'Montserrat', fontSize: 20.0, color: AppColors.SecondaryColor);
  var _formKey = GlobalKey<FormState>();
  var _formview;
  Map _formdata=new Map();
  bool _isLoading = false,_dataLoadingAPI=false;
  BuildContext bContext;
  var _CategoryValue,_description,_max_people;
  DateTime selectedDate = DateTime.now();
  String _title,selectedDateValue = "";
  String selectedTimeValue = "0";
  List inviteTimeRange = new List();
  var _vanueValue; // time array for invites
  int catImageSelected=-1;
  List<Product> imageList=new List<Product>();
  CreateInvitePreseter _createInvitePresenter;
  bool categoryImageViewVisibility=false;

  TimeOfDay selectedTime;
  ValueChanged<DateTime> selectDate;
  ValueChanged<TimeOfDay> selectTime;

  void initState(){
    super.initState();
    _createInvitePresenter= new CreateInvitePreseter(this);
  }

  void changeCategoryImageViewVisibility(bool visible,String cat){
    _createInvitePresenter.CreateInvite_getCategoryImages(cat);
  }

  @override
  void updateCategoryImages(List<dynamic> images){
    imageList.clear();
    for(var i = 0; i < images.length; i++){
      imageList.add(new Product(images[i]['imagepath'].toString(),int.parse(images[i]['id']),-1));
    }
    setState(() {
      categoryImageViewVisibility=true;
      _dataLoadingAPI=false;
    });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        selectedDateValue = selectedDate.year.toString() +
            '-' +
            selectedDate.month.toString() +
            '-' +
            selectedDate.day.toString();
        _formdata['selectedDateValue']=selectedDateValue;
      });
  }



  @override
  Widget build(BuildContext context) {

    bContext = context;

    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.PrimaryColor,
            title: appbarTitle(),
            textTheme: TextTheme(
                title: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0))
        ),
        body: Builder(builder: (context) => createInviteUI(context)));
  }

  Widget appbarTitle(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [new Text("Create new invite"),
        _dataLoadingAPI?new CircularProgressIndicator():new Container()
      ],
    );
  }

  Widget createInviteUI(BuildContext context) {
    _formview = Container(
        color: AppColors.BackgroundColor,
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
                      categoryImageViewVisibility?categoryPictureSelectView():new Container(),
                      descriptionTextEdit(),
                      inviteMembersDropDownContainer(),
                      inviteDateTimeSelect(),
                      vanueDropDownContainer(),
                      Center(
                        child: _isLoading
                            ? new CircularProgressIndicator()
                            : createInviteButton(),
                      ),
                      SizedBox(height: 15.0)

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
            validator:(String arg){
              if(arg.length < 3)
                return 'Name must be more than 2 charater';
              else
                return null;
            },
            onSaved: (String val) {
              _title = val;
              _formdata['_title']=_title;
            },
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "i.e. Explaining flutter univers",
                errorStyle: TextStyle(
                  color: Colors.red,
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
            FormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "Select category";
                  }else return null;
                },
                onSaved: (value) {
                  _formdata['_CategoryValue'] = value;
                },
                builder: (FormFieldState<String> state,) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[_CategoryDropDown(state),SizedBox(height: 5.0),
                  Text(
                  state.hasError ? state.errorText : '',
                  style:
                  TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0))]);
                })
          ],
        ));
  }

  DropdownButton _CategoryDropDown(FormFieldState<String> state) => DropdownButton<String>(
        items: getCategoryList(),
        onChanged: (value) {
          setState(() {
            state.didChange(value);
            _CategoryValue = value;
            _formdata['_CategoryValue']=_CategoryValue;
            _dataLoadingAPI=true;
            changeCategoryImageViewVisibility(true,value);
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

  List<DropdownMenuItem<String>> getCategoryList(){
    List<Categories> cList = new CategoryClass().getCategoryList();
    List<DropdownMenuItem<String>> dropDownList = new List<DropdownMenuItem<String>>();
    for(int i=0;i<cList.length;i++){
      Categories cat = cList[i];
      DropdownMenuItem<String> listItem = new DropdownMenuItem<String>(
        value: cat.txtID,
        child: Text(
          cat.txtCategoryName,
        ),
      );
      dropDownList.add(listItem);
    }
    return dropDownList;
  }



  categoryPictureSelectView() {

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
            FormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "Select category image";
                  }else return null;
                },
                onSaved: (value) {
                  _formdata['catImageSelected'] = value;
                },
                builder: (FormFieldState<String> state,) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new ImageListViewChecked(this,imageList,state),
                        SizedBox(height: 5.0),
                      Text(
                          state.hasError ? state.errorText : '',
                          style:
                          TextStyle(color: Colors.redAccent.shade700, fontSize: 12.0))]);
                })
            ,
          ],
        ));
  }

  void imgSelected(int id,FormFieldState<String> state){
    setState(() {
      state.didChange(id.toString());
      _formdata['catImageSelected'] = id;
      catImageSelected = id;
    });
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
              _description = val;
              _formdata['_description']=_description;
            },
            validator: (String arg){
              if(arg.length<10){
                return   "Please describe invite in detail! Atleast 150 characters";
              }else
                return null;
            },
            buildCounter: counter,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                hintText: "i.e. Describe your invites...",
                errorStyle: TextStyle(
                  color: Colors.red,
                  wordSpacing: 1.0,
                  fontSize: 10
                ),
                border: UnderlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0))),
          ),
        ],
      ),
    );
  }

  Widget counter(
      BuildContext context,
      {
        int currentLength,
        int maxLength,
        bool isFocused,
      }
      ) {
    return Text(
      '($currentLength)',
      semanticsLabel: 'character count',
      style: TextStyle(color: Colors.amber.shade600,fontSize: 12),
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
            FormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "Select max no. people";
                  }else return null;
                },
                onSaved: (value) {
                  _formdata['_max_people'] = value;
                },
                builder: (FormFieldState<String> state,) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[_inviteMembersDropDown(state),SizedBox(height: 5.0),
                      Text(
                          state.hasError ? state.errorText : '',
                          style:
                          TextStyle(color: Colors.redAccent.shade700, fontSize: 10.0))]);
                })
            ,
          ],
        ));
  }

  DropdownButton _inviteMembersDropDown(FormFieldState<String> state) => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "5",
            child: Text(
              "5",
            ),
          ),
          DropdownMenuItem<String>(
            value: "10",
            child: Text(
              "10",
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            state.didChange(value);
            _max_people = value;
            _formdata['_max_people']=_max_people;
          });
        },
        value: _max_people,
        elevation: 2,
        isDense: true,
        hint: Text(
          "Select max no. people who can join!",
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
                        padding: const EdgeInsets.all(1.0),
                        child: FormField<String>(
                          validator: (value) {
                            if (value == null || value=="-1") {
                              return "Please select time!";
                            }else return null;
                          },
                          onSaved: (value) {
                            _formdata['selectedTimeValue'] = value;
                          },
                          builder: (FormFieldState<String> state,) {
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  inviteTimePicker(state),
                                  SizedBox(height: 5.0),
                                  Text(
                                      state.hasError ? state.errorText : '',
                                      style:
                                      TextStyle(color: Colors.redAccent.shade700, fontSize: 10.0))]);
                          }),
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
        _formdata['selectedDateValue']=selectedDateValue;
      },
      validator: (String val){
        if(val.length<5){
          return "Select date!";
        }
        else{
          return null;
        }
      },
      controller: new TextEditingController(text: selectedDateValue),
      decoration: InputDecoration(
          hintText: "Select date",
          errorStyle: TextStyle(
            fontSize: 10,
            color: Colors.red,
            wordSpacing: 5.0,
          ),
          suffixIcon:new IconButton(icon: Image.asset("assets/images/datepicker.png",width: 24,height: 24,), onPressed: (){
            _selectDate(context);
          })),
    );
  }

  RaisedButton inviteTimePicker(FormFieldState<String> state) {
    TimeOfDay _toTime = TimeOfDay.now();
    selectedTime=_toTime;
    return RaisedButton(
        child: new Text(selectedTimeValue,
            style: TextStyle(
                color: AppColors.SecondaryColor,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        padding: EdgeInsets.all(20),
        onPressed: (){_selectTime(bContext,state);});

  }

  Future<void> _selectTime(BuildContext context,FormFieldState<String> state) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTimeValue=picked.format(context);
        state.didChange(selectedTimeValue);
      });
    }
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
            FormField<String>(
                validator: (value) {
                  if (value == null) {
                    return "Please select venue!";
                  }else return null;
                },
                onSaved: (value) {
                  _formdata['_vanueValue'] = value;
                },
                builder: (FormFieldState<String> state,) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _VanueDropDown(state),
                        SizedBox(height: 5.0),
                        Text(
                            state.hasError ? state.errorText : '',
                            style:
                            TextStyle(color: Colors.redAccent.shade700, fontSize: 10.0))]);
                })
          ],
        ));
  }

  DropdownButton _VanueDropDown(FormFieldState<String> state) => DropdownButton<String>(
    items: getVenueList(),
    onChanged: (value) {
      setState(() {
        state.didChange(value);
        _vanueValue = value;
        _formdata['_vanueValue']=_vanueValue;
      });
    },
    value: _vanueValue,
    elevation: 2,
    isDense: true,
    hint: Text(
      "Please select the vanue!",
      style: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  List<DropdownMenuItem<String>> getVenueList(){
    List<DropdownMenuItem<String>> vList= new List<DropdownMenuItem<String>>();
    List<Venue> venueList = VenueClass().getVenueList();

    for(int i=0;i<venueList.length;i++){
      Venue vValue = venueList[i];
      DropdownMenuItem<String> vItem =new DropdownMenuItem<String>(
        value: vValue.txtID,
        child: Text(
            vValue.txtVenue
        ),
      );
      vList.add(vItem);
    }
    return vList;
  }

  createInviteButton(){
    return
        new Material(
          elevation: 5.0,
          borderRadius: BorderRadius.circular(7.0),
          color: AppColors.AcsentVColor,
          child: MaterialButton(
            minWidth: MediaQuery.of(context).size.width * 0.8,
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            onPressed: () {
              validateParams();
            },
            child: Text("Create invite",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
  }

  @override
  void createdSuccessfull() {
    // TODO: implement createdSuccessfull
     _showDialog(bContext,"Create Invite","Invite succesfully created, Check My Events screen!",false);
     _formKey.currentState.reset();
     setState(() => _isLoading = false);
  }

  @override
  void showLoginError(String error) {
    // TODO: implement showLoginError
    if (error == "Session Expired") {
      UserProfile().getInstance().resetUserProfile(); //
      Navigator.of(context).pushReplacementNamed('/Loginscreen');
    } else{
      _showDialog(bContext,"Create Invite","Error while Creating invite, please try again!",false);
    }

    setState(() => _isLoading = false);
  }

  void validateParams(){

    if(catImageSelected==-1){
      _showDialog(bContext, "Category Image", "Please select category image!",false);
      return;
    }
    if (_formKey.currentState.validate()) {
      setState(() => _isLoading = true);
      _formKey.currentState.save();
      Map params = new Map();
      params['title']=_formdata['_title'];
      params['category']=_formdata['_CategoryValue'];
      params['img']=_formdata['catImageSelected'];
      params['desc']=_formdata['_description'];

      params['date']=_formdata['selectedDateValue'];
      params['time']=_formdata['selectedTimeValue'];
      params['max_invite']=_formdata['_max_people'];
      params['vanue']=_formdata['_vanueValue'];
      _createInvitePresenter.CreateInviteOnClick(params);
    }
  }

  //Dialog to notify user about invite creation result
  void _showDialog(BuildContext context,String title, String content,bool isRefresh) {
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
              child: new Text("Close"),
              onPressed: () {
                if (isRefresh)
                  _createInvitePresenter.refreshToken();
                else
                  Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


//  @override
//  void showErrorDialog(String errorMesage) {
//    if(errorMesage=="sessionExpired") {
//      _showDialogNavigation(bContext,"Fetching Invite List", errorMesage,tokenExpired());
//    }
//    else
//      _showDialog(bContext,"Fetching Invite List", errorMesage,true);
//  }
  tokenExpired(){
    UserProfile().getInstance().resetUserProfile();
    Navigator.of(bContext).pushReplacementNamed('/Loginscreen');
  }
  void _showDialogNavigation(BuildContext context, String title, String content,Function fun) {
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

}
