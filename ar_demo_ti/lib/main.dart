import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_demo_ti/examples/localandwebobjectsexample.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  static bool isButtonEnabled = false;
  String _platformVersion = 'Unknown';
  static const String _title = 'AR Demo';
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
    initPlatformState();
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      //developer.log('TI:Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
      //print("TI:connectivity status:" '$_connectionStatus');
      _MyAppState.isButtonEnabled =
          (_connectionStatus.name == 'none') ? false : true;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await ArFlutterPlugin.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(_title),
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/720x1520-background2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(children: [
            Center(
                heightFactor: 1.0,
                child: Text(
                  'Internet: ${_connectionStatus.toString()}',
                  textScaleFactor: 1.5,
                )),
            Text(
              'Running on: $_platformVersion\n',
            ),
            const Expanded(
              child: ExampleList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _infoTile('App name', _packageInfo.appName),
                _infoTile('Package name', _packageInfo.packageName),
                _infoTile('App version', _packageInfo.version),
                // _infoTile('Build number', _packageInfo.buildNumber),
                // _infoTile('Build signature', _packageInfo.buildSignature),
                //_infoTile(
                //  'Installer store',
                //  _packageInfo.installerStore ?? 'not available',
                // ),
              ],
            ),
            const Text(
              'Copyright©Tiszai 2023, All Rights Reserved.',
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 12.0,
                  color: Color(0xFF162A49)),
            ),
          ]),
        ),
      ),
    );
  }
}

class ExampleList extends StatelessWidget {
  const ExampleList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final examples = [
      Example(
          'Online Object',
          'Place 3D objects the web into the scene.\nElhelyez a webről egy 3D testet a kamera képre.',
          () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const LocalAndWebObjectsWidget()))),
    ];
    return ListView(
      children:
          examples.map((example) => ExampleCard(example: example)).toList(),
    );
  }
}

class ExampleCard extends StatelessWidget {
  const ExampleCard({Key? key, required this.example}) : super(key: key);
  final Example example;

  @override
  build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 187, 235, 241),
      child: InkWell(
        splashColor: Colors.blue.withAlpha(30),
        onTap: () {
          //  print("TI:connectivity status 1" '$_MyAppState.isButtonEnabled');
          if (_MyAppState.isButtonEnabled) {
            example.onTap();
          } else {
            //example.onTap();
            showAlertDialog(context, "Internet", '''         Not connected!
               Turn on!
Nincs az internet bekapcsolva!
             Kapcsolja be!''');
          }
        },
        child: ListTile(
          title: Text(example.name),
          subtitle: Text(example.description),
        ),
      ),
    );
  }
}

class Example {
  const Example(this.name, this.description, this.onTap);
  final String name;
  final String description;
  final Function onTap;
}

void showAlertDialog(BuildContext context, String top, String message) {
  // set up the button
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    // title: const Text("Internet"),
    title: Text(top),
    content: Text(message, maxLines: 25),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
