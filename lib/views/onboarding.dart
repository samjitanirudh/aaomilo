import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class OnBoarding extends StatefulWidget {
  final String title;
  OnBoarding({this.title});
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<OnBoarding> {
  int _slideIndex = 0;

  final List<String> images = [
    "assets/slide1.png",
    "assets/slide2.png",
    "assets/slide3.png",
  ];

  final List<String> text0 = [
    "Welcome in your app",
    "Enjoy teaching...",
    "Showcase your skills",
  ];

  final List<String> text1 = [
    "App for food lovers, satisfy your taste",
    "Find best meals in your area, simply",
    "Have fun while eating your relatives and more",
  ];

  final IndexController controller = IndexController();

  @override
  Widget build(BuildContext context) {

    TransformerPageView transformerPageView = TransformerPageView(
        pageSnapping: true,
        onPageChanged: (index) {
          setState(() {
            this._slideIndex = index;
          });
        },
        loop: false,
        controller: controller,
        transformer: new PageTransformerBuilder(
            builder: (Widget child, TransformInfo info) {
              return new Material(
                color: Colors.white,
                elevation: 8.0,
                textStyle: new TextStyle(color: Colors.white),
                borderRadius: new BorderRadius.circular(12.0),
                child: new Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new ParallaxContainer(
                          child: new Text(
                            text0[info.index],
                            style: new TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 34.0,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                          position: info.position,
                          opacityFactor: .8,
                          translationFactor: 400.0,
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                        new ParallaxContainer(
                          child: new Image.asset(
                            images[info.index],
                            fit: BoxFit.contain,
                            height: 350,
                          ),
                          position: info.position,
                          translationFactor: 400.0,
                        ),
                        SizedBox(
                          height: 45.0,
                        ),
                        new ParallaxContainer(
                          child: new Text(
                            text1[info.index],
                            textAlign: TextAlign.center,
                            style: new TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 28.0,
                                fontFamily: 'Quicksand',
                                fontWeight: FontWeight.bold),
                          ),
                          position: info.position,
                          translationFactor: 300.0,
                        ),
                        SizedBox(
                          height: 55.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        itemCount: 4);

    return Scaffold(
      backgroundColor: Colors.white,
      body: transformerPageView,
    );

  }
}