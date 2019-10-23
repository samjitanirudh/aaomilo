import 'package:flutter/material.dart';
import 'package:flutter_meetup_login/views/UserProfileView.dart';

import 'AppColors.dart';

class InviteImageScroller extends StatelessWidget {
  InviteImageScroller(this.photoUrls);

  BuildContext bContext;
  List<String> photoUrls;

  Widget _buildPhoto(BuildContext context, int index) {
    var photo = photoUrls[index];
    return Padding(
        padding: const EdgeInsets.only(right: 1.0),
        child: new GestureDetector(
          onTap: () => {},
          child: new Container(
              decoration: new BoxDecoration(
                color: AppColors.BackgroundColor,
                border: Border.all(width: 3.0, color: Colors.white),
                borderRadius: BorderRadius.all(Radius.circular(5.0) //
                    ),
              ),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Container(
                        width: 190,
                        child:
                      ClipRRect(
                          borderRadius: new BorderRadius.circular(5.0),
                          child: Image.network(photo))
                      )
                    ],
                  ),
                ],
              )),
        ));
  }

  @override
  Widget build(BuildContext context) {
    bContext = context;
    return  new Container(
      height: 200.0,
      child:
        ListView.builder(
          itemCount: photoUrls.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: _buildPhoto,
        ),
      );
  }
}
