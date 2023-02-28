import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ar_demo_ti/examples/BottomSheet.dart';
import 'package:ar_demo_ti/movingobjects.dart';
import 'package:ar_flutter_plugin/managers/ar_location_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_session_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_object_manager.dart';
import 'package:ar_flutter_plugin/managers/ar_anchor_manager.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';
import 'package:ar_flutter_plugin/ar_flutter_plugin.dart';
import 'package:ar_flutter_plugin/datatypes/config_planedetection.dart';
import 'package:ar_flutter_plugin/datatypes/node_types.dart';
import 'package:ar_flutter_plugin/datatypes/hittest_result_types.dart';
import 'package:ar_flutter_plugin/models/ar_hittest_result.dart';
import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';

class LocalAndWebObjectsWidget extends StatefulWidget {
  const LocalAndWebObjectsWidget({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _LocalAndWebObjectsWidgetState createState() =>
      _LocalAndWebObjectsWidgetState();
}

class ListItem {
  int? value;
  String? name;
  String? uri;
  Vector3? scale;
  ListItem({required value, required name, required uri, scale})
      : name = name ?? UniqueKey().toString(),
        uri = uri ?? UniqueKey().toString(),
        value = value ?? 0,
        scale = scale ?? Vector3(0.2, 0.2, 0.2);
}

class _LocalAndWebObjectsWidgetState extends State<LocalAndWebObjectsWidget> {
  ARSessionManager? arSessionManager;
  ARObjectManager? arObjectManager;
  ARAnchorManager? arAnchorManager;
  List<ARAnchor> anchors = [];
  List<ARNode> nodes = [];
  ARNode? newNode;
  MovingObject? moving;
  double? progress = 0;
  bool _stopTimer = false;
  bool _stopTimerRotation = false;
  int elapsedMs = 500;
  Timer? timerrot;
  AlwaysStoppedAnimation<Color>? progressvalueColor =
      const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 252, 1, 1));

  final List<ListItem> _dropdownItems = [
    ListItem(value: 0, name: "None", uri: ""),
    ListItem(
        value: 1,
        name: "Duck (Kacsa)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb"),
    ListItem(
        value: 2,
        name: "Box (Kocka)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Box/glTF-Binary/Box.glb"),
    ListItem(
        value: 3,
        name: "Avocado (Avokádó)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Avocado/glTF-Binary/Avocado.glb",
        scale: Vector3(4.0, 4.0, 4.0)),
    ListItem(
        value: 4,
        name: "Barramundi Fish (Hal)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BarramundiFish/glTF-Binary/BarramundiFish.glb",
        scale: Vector3(1.0, 1.0, 1.0)),
    ListItem(
        value: 5,
        name: "BoxTextured (Kocka felülettel)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BoxTextured/glTF-Binary/BoxTextured.glb"),
    //scale: Vector3(1.0, 1.0, 1.0))
    ListItem(
        value: 6,
        name: "Box Colors (Szines Kocka)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/BoxVertexColors/glTF-Binary/BoxVertexColors.glb"),
    ListItem(
        value: 7,
        name: "Buggy (Bricska)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Buggy/glTF-Binary/Buggy.glb"),
    ListItem(
        value: 8,
        name: "CesiumMan (Cesium ember)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/CesiumMan/glTF-Binary/CesiumMan.glb"),
    ListItem(
        value: 9,
        name: "Fox (Róka)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Fox/glTF-Binary/Fox.glb",
        scale: Vector3(0.1, 0.1, 0.1)),
    ListItem(
        value: 10,
        name: "LightsPunctualLamp (Lámpa)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/LightsPunctualLamp/glTF-Binary/LightsPunctualLamp.glb"),
    ListItem(
        value: 11,
        name: "LightsPunctualLamp (Lámpa)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/LightsPunctualLamp/glTF-Binary/LightsPunctualLamp.glb"),
    ListItem(
        value: 12,
        name: "OrientationTest (---)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/OrientationTest/glTF-Binary/OrientationTest.glb"),
    ListItem(
        value: 13,
        name: "WaterBottle (Vizesüveg)",
        uri:
            "github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/WaterBottle/glTF-Binary/WaterBottle.glb",
        scale: Vector3(0.75, 0.75, 0.75))
  ];
  int? _value = 0;

  void rotobject() {
    try {
      setState(() {
        if (moving!.isrotate![0]) {
          if (moving!.rotation![0] > 360) {
            moving!.rotation![0] = 0;
          } else {
            moving!.rotation![0] = moving!.rotation![0] + 5;
          }
          Matrix4 newMatrix = Matrix4.copy(moving!.webObjectNode!.transform);
          newMatrix.rotate(
              Vector3(1, 0, 0), moving!.rotation![0] * 3.1415927 / 180);
          moving!.webObjectNode!.transform = newMatrix;
        }
        if (moving!.isrotate![1]) {
          if (moving!.rotation![1] > 360) {
            moving!.rotation![1] = 0;
          } else {
            moving!.rotation![1] = moving!.rotation![1] + 5;
          }
          Matrix4 newMatrix = Matrix4.copy(moving!.webObjectNode!.transform);
          newMatrix.rotate(
              Vector3(0, 1, 0), moving!.rotation![1] * 3.1415927 / 180);
          moving!.webObjectNode!.transform = newMatrix;
        }
        if (moving!.isrotate![2]) {
          if (moving!.rotation![2] > 360) {
            moving!.rotation![2] = 0;
          } else {
            moving!.rotation![2] = moving!.rotation![2] + 5;
          }
          Matrix4 newMatrix = Matrix4.copy(moving!.webObjectNode!.transform);
          newMatrix.rotate(
              Vector3(0, 0, 1), moving!.rotation![2] * 3.1415927 / 180);
          moving!.webObjectNode!.transform = newMatrix;
        }
      });
    } catch (error) {
      rethrow;
    }
  }

//https://blog.logrocket.com/understanding-flutter-timer-class-timer-periodic/
  @override
  void initState() {
    super.initState();
    moving = MovingObject(
        webObjectNode: null,
        webAnchor: null,
        position: Vector3.zero(),
        rotation: Vector3.zero(),
        isrotate: [false, false, false]);
    timerrot = Timer.periodic(Duration(milliseconds: elapsedMs), (timerrot) {
      try {
        if (_stopTimerRotation) {
          timerrot.cancel();
        } else {
          if (moving!.webObjectNode != null) {
            rotobject();
          }
        }
      } catch (error) {
        rethrow;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    stopTimerRotation();
    timerrot?.cancel();
    stopTimer();
    arSessionManager!.dispose();
    progressvalueColor = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web Objects (Web-ről testek)'),
      ),
      body: Stack(
        children: [
          ARView(
            onARViewCreated: onARViewCreated,
            planeDetectionConfig: PlaneDetectionConfig.horizontalAndVertical,
          ),
          Center(
              child: CircularProgressIndicator(
            strokeWidth: 10,
            backgroundColor:
                const Color.fromARGB(0, 255, 255, 255).withOpacity(0),
            valueColor: progressvalueColor,
            value: progress,
          )),
          Align(
            alignment: FractionalOffset.bottomCenter,
            heightFactor: 0.15,
            child: Container(
              color: const Color.fromARGB(0, 255, 255, 255).withOpacity(1),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    '3D objects (testek)?',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  DropdownButton(
                    value: _value,
                    isExpanded: true,
                    items: _dropdownItems.map((ListItem item) {
                      return DropdownMenuItem<int>(
                        value: item.value,
                        child: Text(item.name!),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                        if (value == 0) {
                          if (moving!.webObjectNode != null) {
                            arObjectManager!.removeNode(moving!.webObjectNode!);
                            arAnchorManager!.removeAnchor(moving!.webAnchor!);
                            moving!.webObjectNode = null;
                            moving!.webAnchor = null;
                          }
                        }
                        stopTimer();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          MyBottomSheet(
            moving: moving,
          ),
        ],
      ),
    );
  }

  onPanStarted(String nodeName) {}

  onPanChanged(String nodeName) {}

  onPanEnded(String nodeName, Matrix4 newTransform) {}

  onRotationStarted(String nodeName) {}

  onRotationChanged(String nodeName) {}

  onRotationEnded(String nodeName, Matrix4 newTransform) {}

  Future<void> onPlaneOrPointTapped(
      List<ARHitTestResult> hitTestResults) async {
    if (moving!.webObjectNode != null) {
      arObjectManager!.removeNode(moving!.webObjectNode!);
      arAnchorManager!.removeAnchor(moving!.webAnchor!);
      moving!.webObjectNode = null;
      moving!.webAnchor = null;
    }
    try {
      if (_dropdownItems[_value!].name == "None") return;
      if (_dropdownItems[_value!].uri == "") return;

      var singleHitTestResult = hitTestResults.firstWhere(
          (hitTestResult) => hitTestResult.type == ARHitTestResultType.plane);

      // ignore: unrelated_type_equality_checks
      if (singleHitTestResult != ARHitTestResultType.undefined) {
        var newAnchor =
            ARPlaneAnchor(transformation: singleHitTestResult.worldTransform);
        bool? didAddAnchor = await arAnchorManager!.addAnchor(newAnchor);
        if (didAddAnchor!) {
          anchors.add(newAnchor);
          // Add note to anchor
          progress = 0;
          startTimer(max: 6000);
          String uriitem = "https://${_dropdownItems[_value!].uri}";
          var newNode = ARNode(
              type: NodeType.webGLB,
              uri: uriitem,
              //uri:
              //    "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
              //scale: Vector3(0.2, 0.2, 0.2),
              scale: _dropdownItems[_value!].scale,
              position: Vector3(0.0, 0.0, 0.0),
              rotation: Vector4(1.0, 0.0, 0.0, 0.0));
          //  transformation: const MatrixConverter().fromJson(map["transformation"])
          //        ..rotateY(10.0 * 3.1415927 / 180),
          bool? didAddNodeToAnchor =
              await arObjectManager!.addNode(newNode, planeAnchor: newAnchor);
          if (didAddNodeToAnchor!) {
            nodes.add(newNode);
            moving!.webObjectNode = (didAddNodeToAnchor) ? newNode : null;
            moving!.webAnchor = newAnchor;
            stopTimer();
            startTimerRotation(elapsed: 500);
          } else {
            arSessionManager!.onError("Adding Node to Anchor failed");
          }
        } else {
          arSessionManager!.onError("Adding Anchor failed");
        }
      }
      // ignore: empty_catches
    } catch (error) {}
    //print("nPlaneOrPointTapped");
  }

  void onARViewCreated(
      ARSessionManager arSessionManager,
      ARObjectManager arObjectManager,
      ARAnchorManager arAnchorManager,
      ARLocationManager arLocationManager) {
    this.arSessionManager = arSessionManager;
    this.arObjectManager = arObjectManager;
    this.arAnchorManager = arAnchorManager;

    this.arSessionManager!.onInitialize(
          showFeaturePoints: false,
          showPlanes: true,
          customPlaneTexturePath: "assets/triangle.png",
          showWorldOrigin: false,
          //showWorldOrigin: true,
          //showAnimatedGuide: true,
          showAnimatedGuide: false,
          handleTaps: true,
          handleRotation: false,
        );
    this.arObjectManager!.onInitialize();

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    this.arSessionManager!.onPlaneOrPointTap = onPlaneOrPointTapped;
    this.arObjectManager!.onPanStart = onPanStarted;
    this.arObjectManager!.onPanChange = onPanChanged;
    this.arObjectManager!.onPanEnd = onPanEnded;
    this.arObjectManager!.onRotationStart = onRotationStarted;
    this.arObjectManager!.onRotationChange = onRotationChanged;
    this.arObjectManager!.onRotationEnd = onRotationEnded;

    //this.arObjectManager!.onRotationStart;

    //Download model to file system
    //httpClient = HttpClient();
    //_downloadFile(
    //    "https://github.com/KhronosGroup/glTF-Sample-Models/tree/master/2.0/Duck/glTF-Binary/Duck.glb",
    //    "LocalDuck.glb");
    //   "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb"
    // Alternative to use type fileSystemAppFolderGLTF2:
    //_downloadAndUnpack(
    //    "https://drive.google.com/uc?export=download&id=1fng7yiK0DIR0uem7XkV2nlPSGH9PysUs",
    //    "Chicken_01.zip");
  }

  delayed(int sec) async {
    await Future.delayed(Duration(seconds: sec)); // or some time consuming call
    return true;
  }

  void startTimer({double max = 0}) {
    _stopTimer = false;
    Timer.periodic(
      const Duration(milliseconds: 250),
      (Timer timer) => setState(
        () {
          //  print("TI: _stopTimer:" '$_stopTimer');
          if ((progress! >= max) || _stopTimer) {
            progress = 0;
            timer.cancel();
          } else {
            progress = progress! + 0.1;
          }
        },
      ),
    );
  }

  void stopTimer() {
    _stopTimer = true;
  }

  void startTimerRotation({int elapsed = 1000}) {
    _stopTimerRotation = false;
    elapsedMs = elapsed;
  }

  void stopTimerRotation() {
    _stopTimerRotation = true;
  }

  // ignore: duplicate_ignore,, unused_element
  /* Future<void> _downloadAndUnpack(String url, String filename) async {
    var request = await httpClient!.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    // ignore: unnecessary_new
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    // ignore: prefer_adjacent_string_concatenation
    print("Downloading finished, path: " + '$dir/$filename');

    // To print all files in the directory: print(Directory(dir).listSync());
    try {
      await ZipFile.extractToDirectory(
          zipFile: File('$dir/$filename'), destinationDir: Directory(dir));
      print("Unzipping successful");
    } catch (e) {
      // ignore: prefer_interpolation_to_compose_strings
      print("Unzipping failed: " + e.toString());
    }
  }*/

/*  Future<File> _downloadFile(String url, String filename) async {
    try {
      var request = await httpClient!.getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      //String dir = (await getApplicationDocumentsDirectory()).path;
      Directory? dir = (await getExternalStorageDirectory());

      File file = File('$dir/$filename');
      await file.writeAsBytes(bytes);
      print("TI:Downloading finished, path: " '$dir/$filename');
      var b = await file.exists();
      if (b == false) {
        print("TI:error: not exists");
        return File("");
      }

      //data/user/0/com.example.a_demo_ti/app_flutter/LocalDuck.glb
      return file;
    } catch (exp) {
      print("TI:error: $exp");
    }
    return File("");
  }*/

  /* Future<void> onWebObjectAtOriginButtonPressed() async {
    if (GlobalDatas.webObjectNode != null) {
      arObjectManager!.removeNode(GlobalDatas.webObjectNode!);
      GlobalDatas.webObjectNode = null;
      //GlobalDatas.didAddWebNode = false;
    }
    if (_dropdownItems[_value!].uri == "") return;
    progress = 0;
    startTimer(max: 6000);
    String _uriitem = "https://" + _dropdownItems[_value!].uri;
    // await delayed(5);
    //stopTimer();
    //  print("TI:" '$_uriitem');
//https://www.woolha.com/tutorials/flutter-using-circularprogressindicator-examples
    //https://stackoverflow.com/questions/53872082/how-to-fix-my-code-to-show-alert-dialog-on-flutter#:~:text=Here%20is%20the%20full%20error%3A%20I%2Fflutter%20%289767%29%3A%20confirm,showing%20processingdialog%20I%2Fflutter%20%289767%29%3A%20processdialog%20is%20being%20shown.
    //File file = _downloadFile( "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb", "LocalDuck.glb") as File;

    //print(x); // gives true
    //await Future.delayed(Duration(seconds: 5));

    newNode = ARNode(
        type: NodeType.webGLB,
        uri: _uriitem,
        //      uri:
        //          "https://github.com/KhronosGroup/glTF-Sample-Models/raw/master/2.0/Duck/glTF-Binary/Duck.glb",
        //position: Vector3(GlobalDatas.posX, GlobalDatas.posY, GlobalDatas.posZ),
        //  rotation:
        //     Vector4(GlobalDatas.rotX, GlobalDatas.rotY, GlobalDatas.rotZ, 0.0),
        //eulerAngles: Vector3(GlobalDatas.rotX, 0.0, 0.0),
        //transformation: Matrix4.rotationY(0.0009),
        //         const MatrixConverter().fromJson(map["transformation"])
        //           ..rotateY(<degree> * 3.1415927 / 180),
        scale: Vector3(0.1, 0.1, 0.1));
    bool? didAddWebNode = await arObjectManager!.addNode(newNode!);
    print("TI:" '$_uriitem');
    GlobalDatas.webObjectNode = (didAddWebNode!) ? newNode : null;
    stopTimer();
    GlobalDatas.clearPosRotValues();
    //   startTimerRotation(elapsed: 1000);
  }*/
}
