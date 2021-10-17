import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterf/ui/Colors.dart';
import 'package:flutterf/ui/ani/Breathe.dart';
import 'package:flutterf/ui/ani/Folding.dart';
import 'package:flutterf/ui/ani/FoldingBox.dart';
import 'package:flutterf/ui/game/Blendoku.dart';
import 'package:flutterf/ui/game/arithmetic.dart';
import 'package:flutterf/ui/pageroute/OpenTvPageRoute.dart';
import 'package:flutterf/ui/snow/snowman.dart';

import 'maindev.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("home"),
        ),
        body: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  List<String> titles = ["Fold","Arithmetic","Breathe","SnowMain","BlendokuPage",];

  @override
  Widget build(BuildContext context) {
    print('---');
    return Container(
      color: Colors.blueAccent[100],
      child: Center(
        child: buildListView(),
      ),
      padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: 12,
      itemBuilder: (BuildContext context, int inde) {
        return FoldingBox(
          key: ValueKey(inde),
          fold: inde != 0,
            childs: List.generate(titles.length, (index) {
              if (index == 0) {
                return Container(
                  width: 200,
                  height: 100,
                  child: Builder(
                    builder: (BuildContext context) => centerText(titles[index], color: Colors.primaries[index], onPressed: () {
                      FoldingBox.of(context).toTold();
                    }),
                  ),
                );
              } else {
                return centerTextButton(titles[index], color: Colors.primaries[index], onPressed: () {
                  _jump(context, index);
                });
              }
            }),
            foldChild: Container(
              child: Builder(
                  builder: (context) => centerText("Unfold", color: randomColor(), onPressed: () {
                        FoldingBox.of(context).expand();
                      })),
            ));
      },
    );
  }

  void _jump(BuildContext context, int index) {
    print(index.toString());
    switch (index) {
      case 1:
        Navigator.of(context).push(OpenTvPageRoute(child: Arithmetic()));
        break;
      case 2:
        Navigator.of(context).push(OpenTvPageRoute(child: Breathe()));
        break;
      case 3:
        Navigator.of(context).push(OpenTvPageRoute(child: SnowMain()));
        break;
      case 4:
        Navigator.of(context).push(OpenTvPageRoute(child: BlendokuPage()));
        break;
    }
  }
}
