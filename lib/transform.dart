
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class TransformDemo extends StatefulWidget {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  TransformDemo();

  @override
  _TransformDemoState createState() => _TransformDemoState();
}

class _TransformDemoState extends State<TransformDemo> {
  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(

          onMatrixUpdate: (m, tm, sm, rm) {

            setState(() {
              widget.notifier.value = m;

            });
          },
          shouldRotate: true,
          shouldScale: true,
          shouldTranslate: true,
          child: AnimatedBuilder(
            animation: widget.notifier,
            builder: (ctx, child) {
              return Transform(
                transform: widget.notifier.value,
                child:
                Stack(
                  children: [
                    Positioned.fill(
                      child: Container(
                        transform: widget.notifier.value,
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
