import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);

void main() {
  runApp(MyApp());
}

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

  // Are we recording
  bool recording = false;

  // How we get our location
  Geolocator _geolocator = Geolocator();

  Stream<Position> _positionStream;
  StreamSubscription<Position> _positionStreamSubscription;

  String markerId = "YouAreHere";
  Marker here;
  double zoom = 14;
  GoogleMapController mapController;
  Marker youAreHere;
  MarkerId youAreHereId = MarkerId('youarehere');

  @override
  void initState() {
    _positionStream = _geolocator.getPositionStream(locationOptions);
    _positionStreamSubscription = _positionStream.listen((Position position) {
      setState(() {
        if (position == null) {
          latitudeAsSring = 'unknown';
          longitudeAsString = 'unknown';
        } else {
          double latitude = position.latitude;
          double longitude = position.longitude;
          latitudeAsSring =
              ((latitude.abs() * 1000.0).floor() / 1000.0).toString() +
                  (latitude > 0 ? '° N' : '° S');
          longitudeAsString =
              ((longitude.abs() * 1000.0).floor() / 1000.0).toString() +
                  (longitude > 180 ? '° E' : '° W');
          center = LatLng(latitude, longitude);
          if (mapController != null) {
            mapController.getZoomLevel().then((z) {
              zoom = z;
              mapController.animateCamera(CameraUpdate.newCameraPosition(
                  CameraPosition(target: center, zoom: zoom)));
              youAreHere = Marker(
                  markerId: youAreHereId,
                  position: LatLng(position.latitude, position.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta));
            });
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

  List<Widget> view() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
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
                  style: Theme.of(context).textTheme.headline5,
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
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ],
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400, maxHeight: 400),
        child: GoogleMap(
          onMapCreated: onMapCreated,
          initialCameraPosition: CameraPosition(target: center, zoom: zoom),
          markers: youAreHere == null ? null : Set<Marker>.of([youAreHere]),
        ),
      ),
    ];
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
          child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return Column(children: view());
        } else {
          return Row(children: view());
        }
      })),
    );
  }
}
