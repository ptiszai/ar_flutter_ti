// ignore: file_names

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircularProgressIndicatorr extends StatefulWidget {
  double progress = 0;

  CircularProgressIndicatorr({super.key});
  @override
  State<StatefulWidget> createState() {
    return CircularProgressIndicatorState();
  }
}

class CircularProgressIndicatorState extends State<CircularProgressIndicatorr> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Woolha.com Flutter Tutorial'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                strokeWidth: 10,
                backgroundColor: Colors.cyanAccent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                value: widget.progress,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
