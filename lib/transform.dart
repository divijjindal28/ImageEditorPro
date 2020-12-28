import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class TransformDemo extends StatelessWidget {
  Widget child;
  TransformDemo({this.child});
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return  MatrixGestureDetector(
        onMatrixUpdate: (m, tm, sm, rm) {
          print("updated "+ m.toString() + "   "+ tm.toString()+ "   "+ sm.toString()+ "   "+ rm.toString());
          notifier.value = m;
        },
        child: AnimatedBuilder(
          animation: notifier,
          builder: (ctx, child) {
            return Transform(
              transform: notifier.value,
              child: Stack(
                children: <Widget>[

                  Positioned.fill(
                    child: Container(
                      transform: notifier.value,
                      color: Colors.red,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text("hello"),
                      ),
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      );
  }
}
