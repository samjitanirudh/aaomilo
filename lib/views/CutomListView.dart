import 'package:flutter/material.dart';

//Custom list view class
//displays list view with image
//name and designation
//used for Attendee list
class CustomList extends StatefulWidget {
  CustomList();

  @override
  CustomListView createState() {
    // TODO: implement createState
    return new CustomListView();
  }
}

class AttendeeListModel {
  var name;
  var designation;
  var imgPath;

  AttendeeListModel(this.name,  this.imgPath,this.designation);
}

class AttendeeHelper {
  static var attendeeList = [
    AttendeeListModel("Alice", "Lunch in the evening?", "16/07/2018"),
    AttendeeListModel("Jack", "Sure", "16/07/2018"),
    AttendeeListModel("Jane", "Meet this week?", "16/07/2018"),
    AttendeeListModel("Ned", "Received!", "16/07/2018"),
    AttendeeListModel("Steve", "I'll come too!", "16/07/2018")
  ];

  static AttendeeListModel getItem(int position) {
    return attendeeList[position];
  }

  static var itemCount = attendeeList.length;
}

class CustomListView extends State<CustomList> {
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Attendee List'),
      ),
      body: Builder(builder: (context) => getlistUI(context)),
    );

    // TODO: implement build

  }

  getlistUI(BuildContext context){
    return ListView.builder(
      shrinkWrap: false,
      itemBuilder: (context, position) {
        AttendeeListModel attenddeeItem = AttendeeHelper.getItem(position);
        return new Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.account_circle,
                      size: 64.0,
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  attenddeeItem.name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.0),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Text(
                                attenddeeItem.imgPath,
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14.0),
                              ),
                            ),
                            Text(
                              attenddeeItem.designation,
                              style: TextStyle(color: Colors.black45,
                                  fontSize: 12.0),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Divider(),
            ],
          ),
        );
      },
      itemCount: AttendeeHelper.itemCount,
    );
  }
}
