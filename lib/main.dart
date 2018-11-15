import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPS',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'GPS'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  // Sensible defaults for the map view --- San Francisco.
  LatLng center = LatLng(37.7749, -122.4194);

  // The fields we'll show.
  String latitudeAsSring = 'N/A';
  String longitudeAsString = 'N/A';


  var geolocator = Geolocator();
  var locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
  Stream<Position> _positionStream;
  StreamSubscription<Position> _positionStreamSubscription;


  GoogleMapController mapController;

  @override
  void initState() {
    _positionStream = geolocator.getPositionStream(locationOptions);
    _positionStreamSubscription = _positionStream.listen((Position position) {
      setState(() {
        if (position == null) {
          latitudeAsSring = 'unknown';
          longitudeAsString = 'unknown';
        } else {
          double latitude = position.latitude;
          double longitude = position.longitude;
          latitudeAsSring = ((latitude.abs() * 1000.0).floor() / 1000.0).toString() + 
            (latitude > 0 ? '° N' : '° S');
          longitudeAsString = ((longitude.abs() * 1000.0).floor() / 1000.0).toString() + 
            (longitude > 180 ? '° E' : '° W');
          center = LatLng(latitude, longitude);
          if (mapController != null)
          {
            mapController.animateCamera(CameraUpdate.newCameraPosition(
               CameraPosition(target: center, zoom: 12.0)));
          }
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      super.dispose();
      _positionStreamSubscription.cancel();
      _positionStreamSubscription = null;
    }
  }


  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Row(
                // Column is also layout widget. It takes a list of children and
                // arranges them vertically. By default, it sizes itself to fit its
                // children horizontally, and tries to be as tall as its parent.
                //
                // Invoke "debug paint" (press "p" in the console where you ran
                // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
                // window in IntelliJ) to see the wireframe for each widget.
                //
                // Column has various properties to control how it sizes itself and
                // how it positions its children. Here we use mainAxisAlignment to
                // center the children vertically; the main axis here is the vertical
                // axis because Columns are vertical (the cross axis would be
                // horizontal).
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Latitude',
                      ),
                      Text(
                        '$latitudeAsSring',
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Longitude',
                      ),
                      Text(
                        '$longitudeAsString',
                        style: Theme.of(context).textTheme.display1,
                      ),
                    ],
                  ),
                ]),
            SizedBox(
                width: 400,
                height: 400,
                child: GoogleMap(
                    onMapCreated: onMapCreated,
                    options: GoogleMapOptions(
                        trackCameraPosition: true,
                        cameraPosition:
                            CameraPosition(target: center, zoom: 12.0))))
          ],
        ),
      ),
    );
  }
}
