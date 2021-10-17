import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterf/ui/Colors.dart';
import 'package:flutterf/ui/ani/ClickScaleFeedback.dart';
import 'package:flutterf/ui/ani/FoldCard.dart';
import 'package:flutterf/ui/ani/Folding.dart';
import 'package:flutterf/ui/game/Blendoku.dart';
import 'package:flutterf/ui/game/arithmetic.dart';
import 'package:flutterf/ui/snow/snowman.dart';

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
      home: Container(
        color: Colors.blueAccent,
        // child: foldCardTest(),
        child: foldCardTest2(),
      ),
    );
  }

}


foldCardTest() {
  return Container(
    padding: EdgeInsets.only(top: 50),
    child: DefaultTextStyle(
      style: TextStyle(color: Colors.white, fontSize: 20),
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return Folding(
              childs: List.generate(4, (index) {
                if (index == 0) {
                  return Container(
                    width: 200,
                    height: 100,
                    child: Builder(
                      builder: (BuildContext context) => centerText("正面 $index", color: Colors.primaries[index], onPressed: () {
                        Folding.of(context).toTold();
                      }),
                    ),
                  );
                } else {

                  return centerText("正面333 $index", color: Colors.primaries[index],onPressed: (){});
                }
              }),
              foldChild: Container(
                child: Builder(
                    builder: (context) => centerText("折叠的封面", color: randomColor(), onPressed: () {
                      Folding.of(context).expand();
                    })),
              ));
        },
      ),
    ),
  );
}

foldCardTest2() {
  return Container(
    padding: EdgeInsets.only(top: 50),
    child: DefaultTextStyle(
      style: TextStyle(color: Colors.white, fontSize: 20),
      child: ListView.builder(
        itemCount: 2,
        itemBuilder: (BuildContext context, int index) {
          return FoldCard(
              childs: List.generate(4, (index) {
                if (index == 0) {
                  return Container(
                    width: 200,
                    height: 100,
                    child: Builder(
                      builder: (BuildContext context) => centerText("正面 $index", color: Colors.primaries[index], onPressed: () {
                        FoldCard.of(context).toTold();
                      }),
                    ),
                  );
                } else {

                  return centerText("正面 $index", color: Colors.primaries[index]);
                }
              }),
              foldChild: Container(
                child: Builder(
                    builder: (context) => centerText("折叠的封面", color: randomColor(), onPressed: () {
                      FoldCard.of(context).expand();
                    })),
              ));
        },
      ),
    ),
  );
}

Center clickScale() {
  return Center(
    child: Column(
      children: [
        ClickScale(
            onTap: () {
              print("taptap");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("啦啦啦"),
            )),
        ClickScale(
            onTap: () {
              print("taptap222");
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    print("taptap22121212122");
                  },
                  child: Text("啦啦啦")),
            )),
        ClickScale(
          onTap: () {
            print("taptap222");
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset("images/bomei.jpg"),
          ),
        )
      ],
    ),
  );
}

Stack testSnowMain() {
  return Stack(
    alignment: AlignmentDirectional.center,
    fit: StackFit.expand,
    children: [
      SnowMain(),
    ],
  );
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
