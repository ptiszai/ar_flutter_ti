import 'package:ar_flutter_plugin/models/ar_node.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:ar_flutter_plugin/models/ar_anchor.dart';

class MovingObject {
  ARNode? webObjectNode;
  ARPlaneAnchor? webAnchor;
  Vector3? position;
  Vector3? rotation;
  List<bool>? isrotate;
  MovingObject(
      {required webObjectNode,
      required webAnchor,
      required position,
      required rotation,
      required isrotate})
      : position = position ?? Vector3.zero(),
        rotation = rotation ?? Vector3.zero(),
        isrotate = isrotate ?? [false, false, false];
}
