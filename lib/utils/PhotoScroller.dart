import 'package:flutter/material.dart';

class PhotoScroller extends StatelessWidget {
  PhotoScroller(this.photoUrls);

  final List<String> photoUrls;

  Widget _buildPhoto(BuildContext context, int index) {
    print(photoUrls[index]);
    var photo = photoUrls[index];

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage:  NetworkImage(photo),
            radius: 30.0,
          ),
        ],
      ),
    );

//    return Padding(
//      padding: const EdgeInsets.only(right: 16.0),
//      child: ClipRRect(
//        borderRadius: BorderRadius.circular(4.0),
//        child: Image(
//          image: NetworkImage(photo),width: 80,height: 80,
//        ),
//      ),
//    );
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox.fromSize(
          size: const Size.fromHeight(80.0),
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
