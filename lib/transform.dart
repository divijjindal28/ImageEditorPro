
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class TransformDemo extends StatelessWidget {

  Widget child2;
  ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  TransformDemo(this.child2,this.notifier);
  @override
  Widget build(BuildContext context) {
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
                        color: Colors.transparent,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child:child2,
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
