
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class TransformDemo extends StatelessWidget {

  TransformDemo();
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
    return MatrixGestureDetector(

          onMatrixUpdate: (m, tm, sm, rm) {

            notifier.value = m;
          },
          shouldRotate: true,
          shouldScale: true,
          shouldTranslate: true,
          child: AnimatedBuilder(
            animation: notifier,
            builder: (ctx, child) {
              return Transform(
                transform: notifier.value,
                transformHitTests: true,
                child:
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        transform: notifier.value,
                        color: Colors.blue,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text("hello",),
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
