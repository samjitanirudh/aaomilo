import 'package:flutter/material.dart';

class GridViews {
  Card getStructuredGridCell(name, image) {
    return new Card(
        elevation: 1.5,
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            new Image(image: new AssetImage('assets/images/'+ image)),
            new Center(
              child: new Text(name),
            )
          ],
        ));
  }

  GridView build() {
    return new GridView.count(
      primary: true,
      padding: const EdgeInsets.all(1.0),
      crossAxisCount: 2,
      childAspectRatio: 1.0,
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
      children: <Widget>[
        getStructuredGridCell("Facebook", "yoga.jpg"),
        getStructuredGridCell("Twitter", "yoga.jpg"),
        getStructuredGridCell("Instagram", "yoga.jpg"),
        getStructuredGridCell("Linkedin", "yoga.jpg"),
        getStructuredGridCell("Gooogle Plus", "yoga.jpg"),
        getStructuredGridCell("Launcher Icon", "yoga.jpg"),
      ],
    );
  }
}
