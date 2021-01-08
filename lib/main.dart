import 'package:flutter/material.dart';

import 'storages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Storage Demo',
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
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Data Storage Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _string;

  int _restoredCounter = 0;
  String _restoredString = '';

  MyPersistentStorage storage = SharedPreferenceStorage();

  @override
  void initState() {
    super.initState();
    loadValues();
  }

  void loadValues() {
    storage.loadCounter().then((value) {
      setState(() {
        _restoredCounter = value;
      });
    });
    storage.loadString().then((value) {
      setState(() {
        _restoredString = value;
      });
    });
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Counter value:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextField(
              decoration: InputDecoration(labelText: "String to persist: "),
              onChanged: (value) {
                _string = value;
              },
            ),
            Container(margin: EdgeInsets.only(top: 20), child: Text('Restored COUNTER value from persistent storage')),
            Text(
              '$_restoredCounter',
              style: Theme.of(context).textTheme.headline4,
            ),
            Text('Restored STRING value from persistent storage'),
            Text(
              '$_restoredString',
              style: Theme.of(context).textTheme.headline4,
            ),
            Container(margin: EdgeInsets.only(top: 20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: Icon(Icons.upload_rounded), onPressed: loadValues),
                IconButton(
                    icon: Icon(Icons.download_rounded),
                    onPressed: () {
                      setState(() {
                        storage.persist(_string, _counter);
                      });
                    }),
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
