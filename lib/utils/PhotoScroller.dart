import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/tabs/MyProfileTab.dart';

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
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage:  new NetworkImage(photo),
              radius: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(nameList[index].toString()),
            ),
          ],
        ),
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
    var textTheme = Theme.of(context).textTheme;
    bContext=context;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.fromSize(
          size: const Size.fromHeight(120.0),
          child: ListView.builder(
            itemCount: photoUrls.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(top: 8.0, left: 20.0),
            itemBuilder: _buildPhoto,
          ),
        ),
      ],
    );
  }
}
