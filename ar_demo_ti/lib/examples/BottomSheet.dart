// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:ar_demo_ti/movingobjects.dart';
import 'package:ar_demo_ti/main.dart';

//https://protocoderspoint.com/how-to-show-slider-in-bottom-sheet-in-flutter/
// ignore: must_be_immutable
class MyBottomSheet extends StatefulWidget {
  //ar_view_dart minta.
  MovingObject? moving;
  final bool showPlatformType;
  MyBottomSheet({required this.moving, this.showPlatformType = false, Key? key})
      : super(key: key);

  @override
  _MyBottomSheetState createState() =>
      // ignore: no_logic_in_create_state
      _MyBottomSheetState(moving: moving, showPlatformType: showPlatformType);
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  MovingObject? moving;
  bool showPlatformType;
  _MyBottomSheetState({required this.moving, required this.showPlatformType});
  double height = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 0.8,
      widthFactor: 1,
      child: //ElevatedButton(
          ElevatedButton.icon(
        icon: Icon(
          CupertinoIcons.arrow_down_circle_fill,
          color: const Color.fromARGB(0, 4, 248, 114).withOpacity(1),
          size: 30.0,
        ),
        label: const Text('Select moving (mozgás)'),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                //Vector3 temp = widget.moving!.position!;
                return SizedBox(
                    height: 200,
                    child: Column(children: <Widget>[
                      Container(
                        alignment: Alignment.topCenter,
                        height: 14,
                        child: const Text(
                          'Positions, rotation(x,y,z)',
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      StatefulBuilder(builder: (context, state) {
                        return Column(children: <Widget>[
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    // `Alignment(x, y)` = (x * w/2 + w/2, y * h/2 + h/2)
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    alignment: Alignment.topLeft,
                                    //
                                    child: Slider(
                                        value: moving!.position![0],
                                        min: -1.0,
                                        max: 1.0,
                                        label: "X",
                                        onChanged: (double value) {
                                          if (moving != null) {
                                            setState(() {
                                              moving!.position![0] = value;
                                              moving!.webObjectNode!.position =
                                                  moving!.position!;
                                            });
                                            state(() {}); // FONTOS
                                          }
                                        })),
                                Expanded(
                                  child: SwitchListTile(
                                      value: moving!.isrotate![0],
                                      title: const Text('X'),
                                      onChanged: (bool value) {
                                        state(() {}); // FONTOS
                                        setState(() {
                                          moving!.isrotate![0] = value;
                                        }); //FONTOS
                                        //  );
                                      }),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    alignment: Alignment.topLeft,
                                    //
                                    child: Slider(
                                        value: moving!.position![1],
                                        min: -1.0,
                                        max: 1.0,
                                        label: "Y",
                                        onChanged: (double value) {
                                          if (moving!.webObjectNode != null) {
                                            setState(() {
                                              moving!.position![1] = value;
                                              moving!.webObjectNode!.position =
                                                  moving!.position!;
                                            });
                                          }
                                          state(() {}); // FONTOS
                                        })),
                                Expanded(
                                  child: SwitchListTile(
                                      value: moving!.isrotate![1],
                                      title: const Text('Y'),
                                      onChanged: (bool value) {
                                        showAlertDialog(context, "Rotation",
                                            "Y axis under constucion.");
                                        return;
                                      }),
                                ),
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    alignment: Alignment.topLeft,
                                    //
                                    child: Slider(
                                        value: moving!.position![2],
                                        min: -1.0,
                                        max: 1.0,
                                        label: "Z",
                                        onChanged: (double value) {
                                          if (moving!.webObjectNode != null) {
                                            setState(() {
                                              moving!.position![2] = value;
                                              moving!.webObjectNode!.position =
                                                  moving!.position!;
                                            });
                                          }
                                          state(() {}); // FONTOS
                                        })),
                                Expanded(
                                  child: SwitchListTile(
                                      value: moving!.isrotate![2],
                                      title: const Text('Z'),
                                      onChanged: (bool value) {
                                        showAlertDialog(context, "Rotation",
                                            "Z axis under constucion.");
                                        return;
                                      }),
                                ),
                              ]),
                          Text(
                              "pos: ${moving!.position![0].toStringAsFixed(2)},${moving!.position![1].toStringAsFixed(2)},${moving!.position![2].toStringAsFixed(2)}")
                        ]);
                      })
                    ]));
              });
        },
        //child: Text("Select moving (mozgás)"),
      ),
    );
  }
}
