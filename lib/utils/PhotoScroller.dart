import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/tabs/MyProfileTab.dart';

import 'AppColors.dart';

class PhotoScroller extends StatelessWidget {
  PhotoScroller(this.photoUrls,this.nameList,this.userlist);
  BuildContext bContext;
  final List<String> photoUrls,nameList,userlist;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoUrls[index];
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child:
      new GestureDetector(
        onTap: () =>navigateToProfileView(userlist[index]),
        child:
        new Container(
          padding: EdgeInsets.all(10),
          decoration: new BoxDecoration(
            color: AppColors.BackgroundColor,
            border: Border.all(
                width: 3.0,
                color: Colors.white
            ),
            borderRadius: BorderRadius.all(
                Radius.circular(15.0) //
            ),
          ),
          child:
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage:  new NetworkImage(photo),
                    radius: 25.0,
                  ),
                ],
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(nameList[index].toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: AppColors.PurpleVColor),),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(nameList[index].toString(),style: TextStyle(fontSize: 14,color: AppColors.PurpleVColor)),
                )
              ]
            ),
            Icon(Icons.arrow_right)
            ],
          )
        )
        ,
      )

    );

  }

  navigateToProfileView(String user){
    Navigator.push(bContext,
      MaterialPageRoute(
        builder: (context) => MyProfile(userid: user),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bContext=context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListView.builder(
            itemCount: photoUrls.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: _buildPhoto,
          ),
      ],
    );
  }
}
